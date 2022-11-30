{
  config,
  lib,
  ...
}: let
  cfg = config.essentia.amd-gpu;
in
  with lib; {
    options.essentia.amd-gpu = {
      enable = mkEnableOption "AMD GPU support";
    };

    config.hardware.opengl = mkIf cfg.enable {
      enable = true;
    };
  }
