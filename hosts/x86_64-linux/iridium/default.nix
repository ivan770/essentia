{
  config,
  inputs,
  nixosModules,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-laptop-acpi_call
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    nixosModules.users.ivan770
    nixosModules.desktop.generic
    nixosModules.desktop.sway
    nixosModules.hardware.sound
    nixosModules.hardware.systemd-boot
  ];

  config = {
    essentia = {
      home-manager.profiles = {
        ivan770 = "devunit";
      };
      locale = {
        base = "en_US.UTF-8";
        units = "uk_UA.UTF-8";
        timeZone = "Europe/Kiev";
      };
    };

    networking = {
      useDHCP = false;
      networkmanager.enable = true;
    };
    
    programs.light.enable = true;

    security.tpm2.enable = true;

    hardware.enableRedistributableFirmware = true;

    boot.kernelPackages = pkgs.linuxPackages_latest;

    system.stateVersion = "22.05";
  };
}
