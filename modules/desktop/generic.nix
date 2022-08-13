{ lib, pkgs, config, inputs, nixosModules, ... }:

let
  cfg = config.essentia.desktop;
in
with lib; {
  options.essentia.desktop = {
    users = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Users and their corresponding profiles.";
    };
  };

  imports = [
    nixosModules.common.home-manager
    nixosModules.common.locale
    nixosModules.common.nix
    nixosModules.desktop.fonts
    nixosModules.desktop.gnome
    nixosModules.desktop.plymouth
  ];

  config.essentia.home-manager.users = cfg.users;
}
