{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.essentia.printing;
in
  with lib; {
    options.essentia.printing = {
      enable = mkEnableOption "printer and scanner support";
    };

    config = mkIf cfg.enable {
      hardware.sane.enable = true;
      services.printing = {
        enable = true;
        webInterface = false;
        extraConf = ''
          PreserveJobFiles No
          PreserveJobHistory No
        '';
        drivers = with pkgs; [
          gutenprint
          gutenprintBin
        ];
      };
    };
  }
