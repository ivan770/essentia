{ lib, pkgs, config, ... }:

let
  cfg = config.essentia.nvidia;
in
with lib; {
  options.essentia.nvidia = {
    enable = mkEnableOption "Activate Nvidia support for single-card systems";
    vdpau = mkEnableOption "Activate (extremely limited) VDPAU support";
  };

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = [ "nvidia" ];

    environment.variables = mkMerge [
      {
        LIBVA_DRIVER_NAME = "nvidia";
      }
      (mkIf cfg.vdpau {
        VDPAU_DRIVER = "va_gl";
      })
    ];

    hardware = {
      nvidia = {
        nvidiaSettings = false;
        modesetting.enable = true;
        powerManagement.enable = true;
      };
      opengl = {
        enable = true;
        driSupport = true;
        extraPackages = with pkgs; [
          nvidia-vaapi-driver
        ] ++ optionals cfg.vdpau [ libvdpau-va-gl ];
      };
    };
  };
}
