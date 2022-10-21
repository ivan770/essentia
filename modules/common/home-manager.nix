{
  config,
  inputs,
  lib,
  nixosModules,
  fromJSONWithComments,
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

  config = {
    home-manager = {
      extraSpecialArgs = {inherit nixosModules fromJSONWithComments;};
      useGlobalPkgs = true;
      users =
        mapAttrs
        (user: profile: {
          imports = [
            nixosModules.profiles.${user}.${profile}
            {
              programs = {
                bash = {
                  enable = true;
                  enableVteIntegration = true;
                };
                home-manager.enable = true;
              };
            }
          ];
        })
        cfg.profiles;
    };
  };
}
