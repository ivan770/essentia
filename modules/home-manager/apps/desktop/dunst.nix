{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.essentia.programs.dunst;
in
  with lib; {
    options.essentia.programs.dunst = {
      settings = mkOption {
        type = types.attrs;
        default = {};
        description = ''
          Dunst user-specific configuration.
        '';
      };

      cursor = {
        name = mkOption {
          type = types.str;
          default = config.gtk.cursorTheme.name;
          description = ''
            Cursor name for dunst to use.
          '';
        };

        size = mkOption {
          type = types.int;
          default = config.gtk.cursorTheme.size;
          description = ''
            Cursor size for dunst to use.
          '';
        };
      };
    };

    config = {
      services.dunst = {
        enable = true;
        # FIXME: That's a hack.
        waylandDisplay = "wayland-1";
        settings =
          {
            global = {
              follow = "mouse";

              dmenu = runMenu config "Action:";
              mouse_left_click = "do_action";
              mouse_right_click = "close_current";
            };
          }
          // cfg.settings;
      };

      systemd.user.services.dunst.Service.Environment = let
        waylandDisplay = config.services.dunst.waylandDisplay;
      in
        mkForce [
          "XCURSOR_THEME=${cfg.cursor.name}"
          "XCURSOR_SIZE=${toString cfg.cursor.size}"
          # https://github.com/nix-community/home-manager/blob/e7eba9cc46547ae86642ad3c6a9a4fb22c07bc26/modules/services/dunst.nix#L188
          (optionalString (waylandDisplay != "") "WAYLAND_DISPLAY=${waylandDisplay}")
        ];
    };
  }
