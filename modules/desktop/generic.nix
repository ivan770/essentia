{
  lib,
  config,
  nixosModules,
  ...
}: let
  cfg = config.essentia.desktop;
in
  with lib; {
    options.essentia.desktop = {
      wayland = mkEnableOption "Enable Wayland support";

      profiles = mkOption {
        type = types.attrsOf types.str;
        default = {};
        description = "Users and their corresponding profiles.";
      };
    };

    imports = with nixosModules; [
      common.home-manager
      common.global-locale
      common.nix
      desktop.fonts
      desktop.gnome
      desktop.plymouth
    ];

    config.essentia = {
      home-manager.profiles = cfg.profiles;
      gnome.wayland = cfg.wayland;
    };
  }
