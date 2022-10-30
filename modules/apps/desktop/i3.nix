{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.essentia.programs.i3;
in
  with lib; {
    options.essentia.programs.i3 = {
      display = {
        dpi = mkOption {
          type = types.int;
          default = 96;
          description = ''
            Screen DPI value.
          '';
        };
      };

      keyboard = {
        layout = mkOption {
          type = types.str;
          default = "us";
          description = ''
            Keyboard layout configuration.
          '';
        };

        options = mkOption {
          type = types.listOf types.str;
          default = [];
          description = ''
            Keyboard options configuration.
          '';
        };
      };

      settings = mkOption {
        type = types.attrs;
        default = {};
        description = "i3 user-specific settings";
      };
    };

    config = let
      cursor = {
        package = pkgs.gnome.adwaita-icon-theme;
        name = "Adwaita";
        size = 36;
      };
    in {
      gtk = {
        enable = true;
        cursorTheme = {inherit (cursor) package name size;};
        gtk3.extraConfig = {
          gtk-application-prefer-dark-theme = true;
        };
        gtk4.extraConfig = {
          gtk-hint-font-metrics = true;
        };
      };
      home = {
        inherit (cfg) keyboard;
        pointerCursor = {
          inherit (cursor) package name size;
          x11.enable = true;
        };
      };
      xresources.properties = {
        "Xft.dpi" = cfg.display.dpi;
        "Xft.antialias" = true;
        "Xft.autohint" = false;
        "Xft.hinting" = true;
        "Xft.hintstyle" = "hintslight";
        "Xft.lcdfilter" = "lcddefault";
        "Xft.rgba" = "rgb";
      };
      xsession = {
        enable = true;
        windowManager.i3 = {
          enable = true;
          config = cfg.settings;
          extraConfig = ''
            exec --no-startup-id systemctl --user start i3-session.target
          '';
        };
      };
      systemd.user.targets.i3-session = {
        Unit = {
          Description = "i3 compositor session";
          Documentation = ["man:systemd.special(7)"];
          BindsTo = ["graphical-session.target"];
          Wants = ["graphical-session-pre.target"];
          After = ["graphical-session-pre.target"];
        };
      };
    };
  }
