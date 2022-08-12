{ config, pkgs, lib, home-manager, mkAttrsTree, fromJSONWithComments, ... }:

let
  cfg = config.essentia.home-manager;

  modules = builtins.attrValues (mkAttrsTree ./modules);
  users = builtins.attrValues (mkAttrsTree ./users);

  activatedUsers = lib.mapAttrs (name: value: true) cfg.users;
in
{
  options.essentia.home-manager = {
    users = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Users and their corresponding profiles.";
    };
  };

  imports = [
    home-manager.nixosModules.home-manager
  ] ++ users;

  config = {
    essentia.user = activatedUsers;
    home-manager = {
      extraSpecialArgs = { inherit mkAttrsTree fromJSONWithComments; };
      useUserPackages = true;
      users = lib.mapAttrs
        (user: profile: {
          imports = [
            ./users/${user}/${profile}.nix
          ] ++ modules;
        })
        cfg.users;
    };
  };
}
