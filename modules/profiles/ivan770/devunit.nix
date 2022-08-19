{
  config,
  pkgs,
  lib,
  nur,
  nixosModules,
  ...
}: {
  imports = with nixosModules; [
    apps.editors.helix
    apps.editors.vscode
    apps.social.firefox
    apps.utilities.gpg
  ];

  config = {
    home = {
      packages = with pkgs; [
        git
        tdesktop
        rnix-lsp
        swaylock
        wl-clipboard
        alacritty
      ];
      stateVersion = "22.05";
    };
    essentia.programs = {
      firefox =
        import ./firefox/config.nix {inherit nur;}
        // {
          wayland = true;
        };
      gpg.sshKeys = [
        "B0E258EAD4123779C4CFA077DBD8328FD08BADF5"
      ];
      helix.settings = builtins.readFile ./helix/config.toml;
      vscode =
        import ./vscode/config.nix {inherit pkgs;}
        // {
          wayland = true;
        };
    };
    programs = {
      bash = {
        enable = true;
        enableVteIntegration = true;
      };
      home-manager.enable = true;
      waybar = {
        enable = true;
        settings = {
          mainBar = {
            layer = "top";
            modules-left = [
              "network"
            ];
            modules-right = [
              "battery"
              "clock"
            ];

            network = {
              tooltip = false;
              format-wifi = "SSID: {essid}";
              format-ethernet = "";
            };

            battery = {
              states = {
                good = 95;
                warning = 30;
                critical = 20;
              };
              format = "{icon} {capacity}%";
              format-charging = "Charging";
              format-plugged = "Plugged";
              format-alt = "{time} {icon}";
              format-icons = [
                "1"
                "2"
                "3"
                "4"
                "5"
              ];
            };

            clock = {
              format = "%I:%M %p";
            };
          };
        };
        style = builtins.readFile ./waybar/style.css;
      };
    };
    wayland.windowManager.sway = {
      enable = true;
      package = null;
      config = {
        terminal = "alacritty";
        bars = [
          {
            command = "${pkgs.waybar}/bin/waybar";
            position = "top";
          }
        ];
        input."*" = {
          xkb_layout = "us,ru,ua";
          xkb_options = "grp:lalt_lshift_toggle";
        };
        input."type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
          scroll_method = "two_finger";
        };
        bindkeysToCode = true;
        modifier = "Mod4";
      };
    };
  };
}
