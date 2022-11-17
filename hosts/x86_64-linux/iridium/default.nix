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
      common-cpu-amd-pstate
      common-pc
      common-pc-laptop
      common-pc-laptop-acpi_call
      common-pc-laptop-ssd
      ;

    inherit (nixosModules.users.ivan770) home-impermanence user;
    inherit (nixosModules.common) impermanence;
    inherit (nixosModules.desktop) generic sway;
    inherit
      (nixosModules.hardware)
      amd-gpu
      backlight
      bluetooth
      firmware
      networking
      sound
      systemd-boot
      tlp
      tpm
      ;
  };

  essentia = {
    home-manager.profiles.ivan770 = "devunit";
    firmware.cpu.vendor = "amd";
    impermanence.persistentDirectory = "/nix/persist";
    locale = {
      units = "uk_UA.UTF-8";
      timeZone = "Europe/Kiev";
      extendedLocales = true;
    };
    networking = {
      dns.preset = "desktop";
      wireless.networks = [
        "default_5g"
      ];
    };
    tlp.cpu = {
      ac = "performance";
      bat = "schedutil";
    };
  };

  boot = {
    initrd.availableKernelModules = ["nvme" "xhci_pci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];
    kernelModules = ["kvm-amd"];
    kernelPackages = pkgs.linuxPackages_latest;
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
      device = "/dev/disk/by-uuid/97314665-334a-4f4a-a8bd-7c3a86d37527";
      fsType = "f2fs";
      options = [
        "defaults"
        "compress_algorithm=zstd:6"
        "compress_chksum"
        "atgc"
        "gc_merge"
        "lazytime"
        "noatime"
        "nodiscard"
      ];
      neededForBoot = true;
    };

    "/boot/efi" = {
      device = "/dev/disk/by-uuid/73D2-6324";
      fsType = "vfat";
    };
  };

  swapDevices = [{device = "/dev/disk/by-uuid/fc76a365-3349-4c6e-86f0-8bdd2245b259";}];

  system.stateVersion = "22.05";
}
