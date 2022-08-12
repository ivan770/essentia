{ lib, config, ... }:

let
  cfg = config.essentia.steam;
in
with lib; {
  options.essentia.steam = {
    enable = mkEnableOption "Enable Steam support";
  };

  config.programs.steam.enable = cfg.enable;
}
