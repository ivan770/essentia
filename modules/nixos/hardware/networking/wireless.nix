{
  config,
  lib,
  nixosModules,
  pkgs,
  ...
}:
with lib; let
  cfg = config.essentia.networking.wireless;
in {
  options.essentia.networking.wireless = {
    enable = mkEnableOption "wireless networking capabilities";
  };

  config = mkIf cfg.enable {
    networking.wireless.iwd.enable = true;

    environment.systemPackages = [pkgs.iwgtk];
  };
}
