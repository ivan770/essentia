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
      settings = mkOption {
        type = types.nullOr types.attrs;
        default = null;
        description = "Sway user-specific settings";
      };

      nvidia = mkEnableOption "NVIDIA specific configurations";
    };

    config = {
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
        (mkIf (isAttrs cfg.settings) {
          config = cfg.settings;
        })
      ];
    };
  }
