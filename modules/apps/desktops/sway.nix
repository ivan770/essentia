{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.essentia.programs.sway;
in
  with lib; {
    options.essentia.programs.sway = {
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

      nvidia = mkEnableOption "NVIDIA specific configurations";
    };

    config = {
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
          package = pkgs.gnome.adwaita-icon-theme;
          name = "Adwaita";
          size = 36;
        };
      };
      wayland.windowManager.sway = mkMerge [
        {
          enable = true;
          wrapperFeatures = {
            base = true;
            gtk = true;
          };
          extraSessionCommands =
            ''
              export SDL_VIDEODRIVER=wayland
              export QT_QPA_PLATFORM=wayland
              export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
              export NIXOS_OZONE_WL=1
            ''
            + optionalString cfg.nvidia ''
              export WLR_RENDERER=vulkan
              export WLR_NO_HARDWARE_CURSORS=1
              export WLR_DRM_NO_ATOMIC=1
              export VK_LAYER_PATH=${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d
            '';
        }
        (mkIf (isAttrs cfg.swaySettings) {
          config = cfg.swaySettings;
        })
      ];
    };
  }
