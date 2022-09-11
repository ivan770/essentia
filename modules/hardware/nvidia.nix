{pkgs, ...}: {
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
      # It seems that even though nixpkgs already contains installed VA-API shim, removing this section somehow breaks Firefox VA-API detection
      # https://github.com/NixOS/nixpkgs/blob/74a1793c659d09d7cf738005308b1f86c90cb59b/nixos/modules/hardware/video/nvidia.nix#L317-L320
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
      ];
    };
  };
}
