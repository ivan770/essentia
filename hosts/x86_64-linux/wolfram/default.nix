{ config, inputs, nixosModules, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-hdd
    nixosModules.users.ivan770
    nixosModules.desktop.generic
    nixosModules.hardware.grub-efi
    nixosModules.hardware.nvidia
    nixosModules.hardware.printing
    # Required to enable Lunar Client via Flatpak.
    # Nixpkgs' version of Lunar is extremely outdated and isn't working properly
    #
    # In case if you want to disable Flatpak, ensure to completely remove leftover files
    # via flatpak uninstall --all
    # https://discourse.flathub.org/t/how-to-completely-uninstall-any-flatpak-app-on-ubuntu/709
    nixosModules.apps.flatpak
    nixosModules.apps.steam
    nixosModules.apps.gamemode
  ];

  config = {
    essentia = {
      desktop = {
        profiles = {
          ivan770 = "battlestation";
        };
      };
      grub-efi = {
        gfxmode = "1920x1080";
      };
    };

    networking = {
      useDHCP = false;
      interfaces = {
        enp9s0 = {
          useDHCP = true;
        };
      };
    };

    hardware.enableRedistributableFirmware = true;

    boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

    system.stateVersion = "22.05";
  };
}
