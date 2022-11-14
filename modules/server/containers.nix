{
  config,
  lib,
  ...
}: let
  cfg = config.essentia.containers;
in
  with lib; {
    options.essentia.containers = {
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
      serviceConfigurations = filterAttrs (name: _: hasAttr name cfg.activatedConfigurations) cfg.configurations;

      intersectedConfigurations =
        mapAttrs (name: serviceConfiguration: {
          inherit serviceConfiguration;
          userConfiguration = cfg.activatedConfigurations.${name};
        })
        serviceConfigurations;
    in {
      assertions = [
        {
          assertion = (attrNames serviceConfigurations) == (attrNames cfg.configurations);
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
        mapAttrs (name: {
          serviceConfiguration,
          userConfiguration,
        }: {
          inherit (userConfiguration.network) hostAddress localAddress;

          ephemeral = true;
          privateNetwork = true;

          bindMounts =
            mapAttrs (name: mountPoint: {
              inherit mountPoint;

              hostPath = userConfiguration.bindMounts.${name};
              isReadOnly = false;
            })
            serviceConfiguration.bindSlots;

          config = attrs: (serviceConfiguration.config (attrs
            // {
              inherit (userConfiguration.network) localAddress;
            }
            // userConfiguration.specialArgs));
        })
        intersectedConfigurations;
    };
  }
