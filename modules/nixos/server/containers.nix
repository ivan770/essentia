{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.essentia.server.containers;
in
  with lib; {
    options.essentia.server.containers = {
      configurations = mkOption {
        type = types.attrsOf (types.submodule {
          options = {
            config = mkOption {
              # Validation of the config type is delegated to nixpkgs.
              type = types.anything;
              description = ''
                NixOS container configuration.
              '';
            };

            bindSlots = mkOption {
              type = types.attrsOf types.str;
              default = {};
              description = ''
                Filesystem binds that have to be provisioned by an activated container configuration.
              '';
            };

            exposedServices = mkOption {
              type = types.listOf types.str;
              default = {};
              description = ''
                Container's public HTTP services.
              '';
            };
          };
        });
        default = {};
        description = ''
          Supported NixOS containers.
        '';
      };

      activatedConfigurations = mkOption {
        type = types.attrsOf (types.submodule {
          options = {
            bindMounts = mkOption {
              type = types.attrsOf types.str;
              default = {};
              description = ''
                Filesystem binds that are applied to an activated container.
              '';
            };

            specialArgs = mkOption {
              type = types.attrs;
              default = {};
              description = ''
                Extra arguments to pass onto the NixOS container configuration.
              '';
            };
          };
        });
        default = {};
        description = ''
          Activated NixOS containers.
        '';
      };
    };

    config = let
      serviceConfigurations = filterAttrs (name: _: hasAttr name cfg.configurations) cfg.activatedConfigurations;

      networkConfigurations = listToAttrs (zipListsWith
        (name: number: {
          inherit name;
          value = {
            localAddress = "192.168.100.${toString number}";
            hostAddress = "192.168.101.${toString number}";
          };
        }) (attrNames serviceConfigurations) (range 1 254));

      intersectedConfigurations =
        mapAttrs (name: userConfiguration: {
          inherit userConfiguration;
          networkConfiguration =
            (networkConfigurations.${name})
            // {
              exposedServices = listToAttrs (
                zipListsWith (name: value: {inherit name value;}) cfg.configurations.${name}.exposedServices (range 20000 30000)
              );
            };
          serviceConfiguration = cfg.configurations.${name};
        })
        serviceConfigurations;
    in {
      assertions = [
        {
          assertion = (attrNames serviceConfigurations) == (attrNames cfg.activatedConfigurations);
          message = ''
            You can only activate containers that are defined via config.essentia.containers.configurations.
          '';
        }
        {
          assertion = all ({
            serviceConfiguration,
            userConfiguration,
            ...
          }:
            (attrNames serviceConfiguration.bindSlots) == (attrNames userConfiguration.bindMounts)) (attrValues intersectedConfigurations);
          message = ''
            You have to provision all the required filesystem bind slots for each container.
          '';
        }
      ];

      containers =
        mapAttrs (_: {
          networkConfiguration,
          serviceConfiguration,
          userConfiguration,
        }: {
          inherit (networkConfiguration) hostAddress localAddress;

          autoStart = true;
          ephemeral = true;
          privateNetwork = true;

          extraFlags =
            ["-U"]
            ++ (
              attrValues (
                mapAttrs (name: mountPoint: "--bind ${userConfiguration.bindMounts.${name}}:${mountPoint}:idmap") serviceConfiguration.bindSlots
              )
            );

          config = attrs: (serviceConfiguration.config (attrs
            // {
              inherit (networkConfiguration) exposedServices localAddress;
            }
            // userConfiguration.specialArgs));
        })
        intersectedConfigurations;

      # FIXME: Remove "pkgs.lib" if/when https://github.com/NixOS/nixpkgs/pull/157056 gets merged.
      essentia.server.nginx.upstreams = pkgs.lib.recursiveMerge (attrValues (mapAttrs (
          name: {
            networkConfiguration,
            serviceConfiguration,
            userConfiguration,
          }:
            mapAttrs' (
              service: port: nameValuePair "${name}-${service}" "${networkConfiguration.localAddress}:${toString port}"
            )
            networkConfiguration.exposedServices
        )
        intersectedConfigurations));
    };
  }
