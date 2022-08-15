{
  lib,
  pkgs,
  config,
  nixosModules,
  ...
}: let
  cfg = config.essentia.gnome;
in
  with lib; {
    options.essentia.gnome = {
      wayland = mkEnableOption "Enable Wayland support";
      keyringServices = mkEnableOption "Enable GNOME keyring and its related services";
    };

    # GNOME requires NetworkManager and sound anyway
    imports = with nixosModules; [
      hardware.network-manager
      hardware.sound
    ];

    config = {
      services = {
        gnome = mkMerge [
          {
            core-utilities.enable = false;
            chrome-gnome-shell.enable = true;
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
            wayland = cfg.wayland;
          };
          desktopManager.gnome.enable = true;
        };
        udev.packages = with pkgs; [
          gnome.gnome-settings-daemon
        ];
      };

      programs = {
        dconf.enable = true;
        xwayland.enable = cfg.wayland;
      };

      environment.systemPackages = with pkgs; [
        gnome.adwaita-icon-theme
        gnomeExtensions.appindicator
        gnomeExtensions.dash-to-dock
      ];
    };
  }
