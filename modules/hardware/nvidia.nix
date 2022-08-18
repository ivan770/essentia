{
  pkgs,
  config,
  ...
}: {
  config = {
    services.xserver.videoDrivers = ["nvidia"];

    environment.variables = {
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
        extraPackages = with pkgs; [
          nvidia-vaapi-driver
        ];
      };
    };
  };
}
