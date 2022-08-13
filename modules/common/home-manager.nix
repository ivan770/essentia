{ config, pkgs, lib, inputs, nixosModules, mkAttrsTree, fromJSONWithComments, ... }:

let
  cfg = config.essentia.home-manager;

  profiles = builtins.attrValues (mkAttrsTree ../../profiles);
  activatedProfiles = lib.mapAttrs (name: value: true) cfg.profiles;
in
{
  options.essentia.home-manager = {
    profiles = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Users and their corresponding profiles.";
    };
  };

  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  config = {
    home-manager = {
      extraSpecialArgs = { inherit pkgs inputs nixosModules mkAttrsTree fromJSONWithComments; };
      useUserPackages = true;
      users = lib.mapAttrs
        (user: profile: {
          imports = [
            ../../profiles/${user}/${profile}.nix
          ];
        })
        cfg.profiles;
    };
  };
}
