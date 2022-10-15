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

      systemd = {
        enable = mkEnableOption "yambar systemd integration";
        target = mkOption {
          type = types.str;
          default = "sway-session.target";
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

      (mkIf cfg.systemd.enable {
        systemd.user.services.yambar = {
          Unit = {
            Description = "Modular status panel for X11 and Wayland, inspired by polybar.";
            Documentation = "https://gitlab.com/dnkl/yambar/-/blob/master/README.md";
            PartOf = ["graphical-session.target"];
            After = ["graphical-session.target"];
          };

          Service = {
            ExecStart = "${pkgs.yambar}/bin/yambar";
            ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
            Restart = "on-failure";
            KillMode = "mixed";
          };

          Install = {WantedBy = [cfg.systemd.target];};
        };
      })
    ];
  }
