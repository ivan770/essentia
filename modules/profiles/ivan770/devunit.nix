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
        settings = import ./sway/waybar/bars.nix {};
        style = builtins.readFile ./sway/waybar/style.css;
      };
    };
    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures = {
        base = true;
        gtk = true;
      };
      extraSessionCommands = ''
        export SDL_VIDEODRIVER=wayland
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      '';
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
