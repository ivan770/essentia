{
  config,
  lib,
  ...
}: let
  cfg = config.essentia.steam-hardware;
in
  with lib; {
    options.essentia.steam-hardware = {
      enable = mkEnableOption "Steam hardware support";
    };

    config.hardware.steam-hardware = mkIf cfg.enable {
      enable = true;
    };
  }
