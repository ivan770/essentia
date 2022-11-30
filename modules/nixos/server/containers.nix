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
              type = types.attrsOf types.int;
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

            network = {
              hostAddress = mkOption {
                type = types.str;
                description = ''
                  Host interface IPv4 address.
                '';
              };

              localAddress = mkOption {
                type = types.str;
                description = ''
                  Container interface IPv4 address.
                '';
              };
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

      intersectedConfigurations =
        mapAttrs (name: userConfiguration: {
          inherit userConfiguration;
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
          }:
            (attrNames serviceConfiguration.bindSlots) == (attrNames userConfiguration.bindMounts)) (attrValues intersectedConfigurations);
          message = ''
            You have to provision all the required filesystem bind slots for each container.
          '';
        }
      ];

      containers =
        mapAttrs (_: {
          serviceConfiguration,
          userConfiguration,
        }: {
          inherit (userConfiguration.network) hostAddress localAddress;

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
              inherit (userConfiguration.network) localAddress;
              inherit (serviceConfiguration) exposedServices;
            }
            // userConfiguration.specialArgs));
        })
        intersectedConfigurations;

      # FIXME: Remove "pkgs.lib" if/when https://github.com/NixOS/nixpkgs/pull/157056 gets merged.
      essentia.server.nginx.upstreams = pkgs.lib.recursiveMerge (attrValues (mapAttrs (
          name: {
            serviceConfiguration,
            userConfiguration,
          }:
            mapAttrs' (
              service: port: nameValuePair "${name}-${service}" "${userConfiguration.network.localAddress}:${toString port}"
            )
            serviceConfiguration.exposedServices
        )
        intersectedConfigurations));
    };
  }
