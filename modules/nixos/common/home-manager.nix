{
  config,
  lib,
  inputs,
  nixosModules,
  ...
}:
with lib; let
  cfg = config.essentia.home-manager;
in {
  options.essentia.home-manager = {
    profiles = mkOption {
      type = types.attrsOf types.str;
      default = {};
      description = "Users and their corresponding profiles.";
    };
  };

  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  config = mkIf (cfg.profiles != {}) {
    essentia.impermanence.users =
      mapAttrs (_: modules: modules.essentia.home-impermanence) config.home-manager.users;

    home-manager = {
      extraSpecialArgs = {inherit nixosModules;};
      useGlobalPkgs = true;
      sharedModules = [
        {
          options.essentia.home-impermanence = {
            directories = mkOption {
              # Let impermanence module handle the typeck
              type = with types; listOf (either attrs str);
              default = [
                # .*
                {
                  directory = ".cache";
                  mode = "0700";
                }
                {
                  directory = ".pki";
                  mode = "0700";
                }

                # .config/*
                {
                  directory = ".config/dconf";
                  mode = "0700";
                }

                # .local/*
                {
                  directory = ".local/state/wireplumber";
                  mode = "0700";
                }
              ];
            };

            files = mkOption {
              type = with types; listOf (either attrs str);
              default = [
                ".bash_history"
                {
                  file = ".ssh/known_hosts";
                  parentDirectory = {mode = "0700";};
                }
              ];
            };
          };

          config = {
            programs = {
              bash = {
                enable = true;
                enableVteIntegration = true;
              };
              home-manager.enable = true;
            };

            home.stateVersion = config.system.stateVersion;
          };
        }
      ];
      users = mapAttrs (user: profile: {
          config,
          lib,
          pkgs,
          ...
        } @ args:
          lib.mkCall args nixosModules.home-manager.profiles.${user}.${profile} {})
      cfg.profiles;
    };
  };
}
