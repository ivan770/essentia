{ config, nixos-hardware, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-pc-hdd
  ];

  essentia = {
    desktop = {
      enable = true;
      users = {
        ivan770 = "battlestation";
      };
    };
    # Required to enable Lunar Client via Flatpak.
    # Nixpkgs' version of Lunar is extremely outdated and isn't working properly
    flatpak.enable = true;
    grub-efi = {
      enable = true;
      gfxmode = "1920x1080";
    };
    nvidia.enable = true;
    printing.enable = true;
  };

  networking = {
    useDHCP = false;
    interfaces = {
      enp9s0 = {
        useDHCP = true;
      };
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_xanmod;

  system.stateVersion = "22.05";
}
