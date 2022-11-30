{
  config,
  lib,
  ...
}: let
  cfg = config.essentia.nvidia;
in
  with lib; {
    options.essentia.nvidia = {
      enable = mkEnableOption "Nvidia GPU support";
    };

    config = mkIf cfg.enable {
      services.xserver.videoDrivers = ["nvidia"];

      environment.variables = {
        GBM_BACKEND = "nvidia-drm";
        LIBVA_DRIVER_NAME = "nvidia";
      };

      hardware = {
        nvidia = {
          nvidiaSettings = false;
          modesetting.enable = true;
          powerManagement.enable = true;
        };
        opengl = {
          enable = true;
          driSupport = true;
          driSupport32Bit = true;
        };
      };
    };
  }
