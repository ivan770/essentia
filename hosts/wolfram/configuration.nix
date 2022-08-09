{ config, nixos-hardware, pkgs, ... }:

{
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  imports = [
    ./hardware-configuration.nix
    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-pc-hdd
  ];

  essentia = {
    desktop = {
      enable = true;
      home-manager = true;
    };
    grub-efi.enable = true;
    networking.enable = true;
    nvidia.enable = true;
    printing.enable = true;
    sound.enable = true;
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
