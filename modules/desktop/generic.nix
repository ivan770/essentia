{ lib, pkgs, config, inputs, nixosModules, ... }:

let
  cfg = config.essentia.desktop;
in
with lib; {
  options.essentia.desktop = {
    wayland = mkEnableOption "Enable Wayland support";

    profiles = mkOption {
      type = types.attrsOf types.str;
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

  config.essentia = {
    home-manager.profiles = cfg.profiles;
    gnome.wayland = cfg.wayland;
  };
}
