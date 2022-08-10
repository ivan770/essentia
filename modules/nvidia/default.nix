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

    environment.variables.VDPAU_DRIVER = "nvidia";

    hardware = {
      nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;
      };
      opengl = {
        enable = true;
        driSupport = true;
        extraPackages = with pkgs; [
          nvidia-vaapi-driver
          vaapiVdpau
          libvdpau-va-gl
        ];
      };
    };
  };
}
