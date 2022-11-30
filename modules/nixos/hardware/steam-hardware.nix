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

    config.hardware.steam-hardware.enable = cfg.enable;
  }
