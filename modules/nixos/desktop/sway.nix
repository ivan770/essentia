{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.essentia.desktop.sway;
in
  with lib; {
    options.essentia.desktop.sway = {
      enable = mkEnableOption "Sway desktop support";
    };

    config = mkIf cfg.enable {
      programs.dconf.enable = true;
      xdg.portal = {
        enable = true;
        wlr = {
          enable = true;
          settings = {
            screencast = {
              max_fps = 30;
              chooser_type = "dmenu";
              chooser_cmd = "${pkgs.bemenu}/bin/bemenu --list 10 -c -W 0.5 -f";
            };
          };
        };
      };
      services = {
        dbus = {
          enable = true;
          packages = [pkgs.gcr];
        };
        greetd = {
          enable = true;
          settings = {
            default_session = {
              command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
              user = "greeter";
            };
          };
        };
      };
    };
  }
