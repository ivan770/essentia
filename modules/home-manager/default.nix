{ config, pkgs, lib, flake-self, home-manager, ... }:

let
  cfg = config.essentia.home-manager;

  modules = map (x: import ./modules/${x}) (builtins.attrNames (builtins.readDir ./modules));
  users = map (x: import ./users/${x}) (builtins.attrNames (builtins.readDir ./users));

  activatedUsers = lib.listToAttrs (map (name: { inherit name; value = true; }) (builtins.attrNames cfg.users));
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
      useUserPackages = true;
      users = lib.mapAttrs
        (user: profile: {
          imports = [
            { nixpkgs.overlays = [ flake-self.overlays.default ]; }
            ./users/${user}/${profile}.nix
          ] ++ modules;
        })
        cfg.users;
    };
  };
}
