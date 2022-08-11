{ lib, pkgs, config, ... }:

let
  cfg = config.essentia.gnome;
in
with lib; {
  options.essentia.gnome = {
    enable = mkEnableOption "Enable GNOME desktop";
    keyringServices = mkEnableOption "Enable GNOME keyring and its related services";
  };

  config = mkIf cfg.enable {
    # GNOME requires networking and sound anyway
    essentia = {
      networking.enable = true;
      sound.enable = true;
    };
    services = {
      gnome = mkMerge [
        {
          core-utilities.enable = false;
        }
        # Remove capability to disable keyring as soon as https://github.com/NixOS/nixpkgs/issues/166887
        # gets resolved.
        (mkIf (!cfg.keyringServices) {
          gnome-online-accounts.enable = mkForce false;
          gnome-keyring.enable = mkForce false;
        })
      ];
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
