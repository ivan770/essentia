{
  config,
  nixosModules,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    nixosModules.users.ivan770
    nixosModules.hardware.networking
    nixosModules.hardware.systemd-boot
    nixosModules.server.generic
  ];

  config = {
    essentia = {
      networking.wired = true;
      systemd-boot.mountpoint = "/boot";
    };

    boot.cleanTmpDir = true;
    zramSwap.enable = true;

    hardware.enableRedistributableFirmware = true;

    boot.kernelPackages = pkgs.linuxPackages_latest;

    system.stateVersion = "22.05";
  };
}
