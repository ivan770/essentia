{ lib, pkgs, config, ... }:

let
  cfg = config.essentia.networking;
in
with lib; {
  options.essentia.networking = {
    enable = mkEnableOption "Activate networking";
  };

  config = mkIf cfg.enable {
    networking.networkmanager.enable = true;
  };
}
