{ lib, pkgs, config, ... }:

let
  cfg = config.essentia.gnome;
in
with lib; {
  options.essentia.gnome = {
    enable = mkEnableOption "Enable GNOME desktop";
  };

  config = mkIf cfg.enable {
    services = {
      gnome.core-utilities.enable = false;
      xserver = {
        enable = true;
        layout = "us";
        displayManager.gdm = {
          enable = true;
          wayland = true;
        };
        desktopManager.gnome.enable = true;
      };
      udev.packages = with pkgs; [
        gnome.gnome-settings-daemon
      ];
    };

    programs = {
      dconf.enable = true;
      xwayland.enable = true;
    };

    environment.systemPackages = with pkgs; [
      gnome.adwaita-icon-theme
      gnomeExtensions.appindicator
      gnomeExtensions.dash-to-dock
    ];
  };
}
