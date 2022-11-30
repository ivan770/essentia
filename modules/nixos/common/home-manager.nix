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

  config.home-manager = mkIf (cfg.profiles != {}) {
    extraSpecialArgs = {inherit nixosModules;};
    useGlobalPkgs = true;
    sharedModules = [
      {
        home.stateVersion = config.system.stateVersion;
        programs = {
          bash = {
            enable = true;
            enableVteIntegration = true;
          };
          home-manager.enable = true;
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
}
