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

    inherit (nixosModules.common) systemd-initrd;
    inherit (nixosModules.users.ivan770) user;
    inherit (nixosModules.desktop) generic i3;
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

  config = {
    essentia = {
      home-manager.profiles.ivan770 = "battlestation";
      firmware.cpu.vendor = "amd";
      locale = {
        units = "uk_UA.UTF-8";
        timeZone = "Europe/Kiev";
        extendedLocales = true;
      };
      networking = {
        dns.preset = "desktop";
        wired.enable = true;
      };
      secrets.postgresql = "client";
    };

    boot = {
      initrd.availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
      kernelModules = ["kvm-amd"];
    };

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/5d431071-4cc8-47c8-8c3c-25c91c651a5d";
      fsType = "ext4";
      options = [
        "noatime"
        "commit=30"
      ];
    };

    fileSystems."/boot/efi" = {
      device = "/dev/disk/by-uuid/7880-E722";
      fsType = "vfat";
    };

    swapDevices = [{device = "/dev/disk/by-uuid/82b0acf4-9271-4e28-94b4-13bb56341200";}];

    boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

    system.stateVersion = "22.05";
  };
}
