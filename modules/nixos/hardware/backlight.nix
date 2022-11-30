{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.essentia.backlight;
in
  with lib; {
    options.essentia.backlight = {
      enable = mkEnableOption "display backlight support";
    };

    config = mkIf cfg.enable {
      programs.light.enable = true;
      services.acpid = {
        enable = true;
        handlers = {
          brightnessUp = {
            event = "video/brightnessup";
            action = "${pkgs.light}/bin/light -A 5";
          };
          brightnessDown = {
            event = "video/brightnessdown";
            action = "${pkgs.light}/bin/light -U 5";
          };
        };
      };
    };
  }
