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

      mouse = {
        profile = mkOption {
          type = types.enum ["adaptive" "flat"];
          default = "flat";
          description = ''
            Preferred mouse acceleration profile.
          '';
        };

        speed = mkOption {
          type = types.number;
          default = 0;
          description = ''
            Preferred mouse acceleration speed.
          '';
        };
      };

      config = mkOption {
        type = types.attrs;
        default = {};
        description = ''
          i3 user-specific settings.
        '';
      };

      extraConfig = mkOption {
        type = types.str;
        default = "";
        description = ''
          Extra i3 configuration.
        '';
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
          inherit (cfg) config;

          enable = true;
          extraConfig =
            cfg.extraConfig
            + ''
              exec --no-startup-id systemctl --user start i3-session.target
            '';
        };
      };
      systemd.user = {
        services.libinput-mouse-accel = {
          Unit = {
            Description = "libinput mouse acceleration configurator";
            After = ["graphical-session-pre.target"];
            PartOf = ["graphical-session.target"];
          };

          Service = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = let
              xinput = "${pkgs.xorg.xinput}/bin/xinput";
              grep = "${pkgs.gnugrep}/bin/grep";
              wc = "${pkgs.coreutils}/bin/wc";

              devices = concatStringsSep "|" [
                "Mouse"
                "Touchpad"
              ];

              accelerationConfig = {
                "libinput Accel Profile Enabled" =
                  if cfg.mouse.profile == "adaptive"
                  then "1 0"
                  else "0 1";
                "libinput Accel Speed" = cfg.mouse.speed;
              };

              # To ignore matches like "libinput Accel Profile Enabled Default"
              # an unmatched brace is left at the end of a pattern.
              patterns = mapAttrsToList (name: _: "${name} \\(") accelerationConfig;

              regex = concatMapStringsSep "|" (pattern: "(${pattern})") patterns;

              configurator = concatStringsSep "\n" (
                mapAttrsToList (
                  name: value: "${xinput} set-prop \"$device\" \"${name}\" ${toString value}"
                )
                accelerationConfig
              );

              script = pkgs.writeShellScript "libinput-mouse-config.sh" ''
                ${xinput} list --name-only | ${grep} -E "(${devices})" | while read -r line
                do
                  device="pointer:$line"

                  count=$(${xinput} list-props "$device" | ${grep} -E "${regex}" | ${wc} -l)

                  if [ "$count" -eq ${toString (length patterns)} ]
                  then
                    ${configurator}
                  fi
                done
              '';
            in (toString script);
          };

          Install = {
            WantedBy = ["graphical-session.target"];
          };
        };

        targets.i3-session = {
          Unit = {
            Description = "i3 compositor session";
            Documentation = ["man:systemd.special(7)"];
            BindsTo = ["graphical-session.target"];
            Wants = ["graphical-session-pre.target"];
            After = ["graphical-session-pre.target"];
          };
        };
      };
    };
  }
