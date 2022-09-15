{
  config,
  pkgs,
  lib,
  inputs,
  nixosModules,
  fromJSONWithComments,
  ...
}: let
  cfg = config.essentia.home-manager;
in {
  options.essentia.home-manager = {
    profiles = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Users and their corresponding profiles.";
    };
  };

  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  config = {
    home-manager = {
      extraSpecialArgs = {
        # FIXME: Pls remove this mess.
        inherit inputs nixosModules fromJSONWithComments;
        nur = config.nur;
        sops = config.sops;
      };
      useGlobalPkgs = true;
      users =
        lib.mapAttrs
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
