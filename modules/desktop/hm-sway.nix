{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.essentia.sway;
in
  with lib; {
    options.essentia.sway = {
      swaySettings = mkOption {
        type = types.nullOr types.attrs;
        default = null;
        description = "Sway user-specific settings";
      };

      waybarSettings = mkOption {
        type = types.nullOr types.attrs;
        default = null;
        description = "Waybar user-specific settings";
      };

      waybarStyle = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Waybar user-specific CSS styles";
      };
    };

    config = {
      home.packages = with pkgs; [
        bemenu
        pinentry-gnome
        swaylock
        wl-clipboard
        grim
      ];
      programs.waybar = mkMerge [
        {
          enable = true;
          systemd = {
            enable = true;
            target = "sway-session.target";
          };
        }
        (mkIf (isAttrs cfg.waybarSettings) {
          settings = cfg.waybarSettings;
        })
        (mkIf (isString cfg.waybarStyle) {
          style = cfg.waybarStyle;
        })
      ];
      gtk = {
        enable = true;
        cursorTheme = {
          name = "Adwaita";
          size = 48;
        };
      };
      wayland.windowManager.sway = mkMerge [
        {
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
        }
        (mkIf (isAttrs cfg.swaySettings) {
          config = cfg.swaySettings;
        })
      ];
    };
  }
