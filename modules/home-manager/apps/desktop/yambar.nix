{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.essentia.programs.yambar;

  yamlFormat = pkgs.formats.yaml {};
  configFile = yamlFormat.generate "yambar.yaml" cfg.settings;
in
  with lib; {
    options.essentia.programs.yambar = {
      settings = mkOption {
        type = yamlFormat.type;
        default = {};
        example = literalExpression ''
          {
            bar = {
              height = 26;
              location = "top";
              background = "000000ff";
            };
          }
        '';
        description = ''
          Configuration written to
          <filename>$XDG_CONFIG_HOME/yambar/config.yml</filename>.
        '';
      };

      cursor = {
        name = mkOption {
          type = types.str;
          default = config.gtk.cursorTheme.name;
          description = ''
            Cursor name for yambar to use.
          '';
        };

        size = mkOption {
          type = types.int;
          default = config.gtk.cursorTheme.size;
          description = ''
            Cursor size for yambar to use.
          '';
        };
      };

      systemd = {
        target = mkOption {
          type = types.nullOr (types.enum ["i3" "sway"]);
          default = null;
          description = ''
            The systemd target that will automatically start the yambar service.
          '';
        };
      };
    };

    config = mkMerge [
      {
        xdg.configFile."yambar/config.yml" = {
          source = configFile;
          onChange = ''
            ${pkgs.procps}/bin/pkill -u $USER -USR2 yambar || true
          '';
        };
      }

      (mkIf (isString cfg.systemd.target) {
        systemd.user.services.yambar = {
          Unit = {
            Description = "yambar, a modular status panel for X11 and Wayland";
            Documentation = "https://gitlab.com/dnkl/yambar/-/blob/master/README.md";
            PartOf = ["graphical-session.target"];
          };

          Service = {
            ExecStart = "${pkgs.yambar}/bin/yambar";
            ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
            Environment = [
              "XCURSOR_THEME=${cfg.cursor.name}"
              "XCURSOR_SIZE=${toString cfg.cursor.size}"
            ];
            Restart = "on-failure";
            KillMode = "mixed";
          };

          Install = {WantedBy = ["${cfg.systemd.target}-session.target"];};
        };
      })
    ];
  }
