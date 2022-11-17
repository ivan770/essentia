{
  inputs,
  nixosModules,
  pkgs,
  ...
}: {
  imports = builtins.attrValues {
    inherit
      (inputs.nixos-hardware.nixosModules)
      common-cpu-amd
      common-pc
      common-pc-hdd
      ;

    inherit (nixosModules.common) impermanence systemd-initrd;
    inherit (nixosModules.users.ivan770) home-impermanence user;
    inherit (nixosModules.desktop) generic i3 virtualbox;
    inherit
      (nixosModules.hardware)
      firmware
      gaming
      networking
      nvidia
      printing
      sound
      systemd-boot
      tpm
      ;
  };

  essentia = {
    home-manager.profiles.ivan770 = "battlestation";
    firmware.cpu.vendor = "amd";
    impermanence.persistentDirectory = "/nix/persist";
    locale = {
      units = "uk_UA.UTF-8";
      timeZone = "Europe/Kiev";
      extendedLocales = true;
    };
    networking = {
      dns.preset = "desktop";
      wired.enable = true;
    };
  };

  boot = {
    initrd.availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
    kernelModules = ["kvm-amd"];
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    kernelParams = [
      # Fix incorrect resolution with disabled bootloader menu
      "video=efifb:auto"
    ];
  };

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [
        "defaults"
        "size=3G"
        "mode=755"
      ];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/ca952a5f-a2fc-4536-b73f-3f267e66a8d6";
      fsType = "ext4";
      options = [
        "noatime"
        "commit=30"
      ];
    };

    "/boot/efi" = {
      device = "/dev/disk/by-uuid/FDC7-96EA";
      fsType = "vfat";
    };
  };

  swapDevices = [{device = "/dev/disk/by-uuid/82b0acf4-9271-4e28-94b4-13bb56341200";}];

  system.stateVersion = "22.05";
}
