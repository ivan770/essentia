{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.essentia.programs.feh;
in
  with lib; {
    options.essentia.programs.feh = {
      image = mkOption {
        type = types.str;
        description = ''
          Path to an image that will be used as a desktop background.
        '';
      };

      systemd.target = mkOption {
        type = types.str;
        default = "graphical-session.target";
        description = ''
          The systemd target that will automatically start the feh service.
        '';
      };
    };

    config = {
      systemd.user.services.feh = {
        Unit = {
          Description = "feh, a light-weight image viewer";
          Documentation = "https://man.finalrewind.org/1/feh/";
          PartOf = ["graphical-session.target"];
        };

        Service = {
          ExecStart = "${pkgs.feh}/bin/feh --bg-scale ${cfg.image}";
          ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
          Restart = "on-failure";
          KillMode = "mixed";
        };

        Install = {WantedBy = [cfg.systemd.target];};
      };
    };
  }
