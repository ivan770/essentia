{ lib, pkgs, config, ... }:

let
  cfg = config.essentia.nvidia;
in
with lib; {
  options.essentia.nvidia = {
    enable = mkEnableOption "Activate Nvidia support for single-card systems";
  };

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.opengl = {
      enable = true;
      extraPackages = with pkgs; [
        vaapiVdpau
      ];
    };
  };
}
