{ lib, config, ... }:

let
  cfg = config.essentia.flatpak;
in
with lib; {
  options.essentia.flatpak = {
    enable = mkEnableOption "Activate Flatpak support";
  };

  config.services.flatpak.enable = cfg.enable;
}
