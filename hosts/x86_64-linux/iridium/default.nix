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
      common-gpu-amd
      common-pc
      common-pc-laptop
      common-pc-laptop-acpi_call
      common-pc-laptop-ssd
      ;

    inherit (nixosModules.users.ivan770) impermanence user;
    inherit (nixosModules.common) impermanence;
    inherit (nixosModules.desktop) generic sway;
    inherit
      (nixosModules.hardware)
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

  config = {
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
        wireless = [
          "default_5g"
        ];
        desktopDns = true;
      };
      tlp.cpu = {
        ac = "performance";
        bat = "schedutil";
      };
    };

    boot = {
      initrd.availableKernelModules = ["nvme" "xhci_pci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];
      kernelModules = ["kvm-amd"];
    };

    fileSystems."/" = {
      device = "none";
      fsType = "tmpfs";
      options = [
        "defaults"
        "size=3G"
        "mode=755"
      ];
    };

    fileSystems."/nix" = {
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
      ];
      neededForBoot = true;
    };

    fileSystems."/boot/efi" = {
      device = "/dev/disk/by-uuid/73D2-6324";
      fsType = "vfat";
    };

    swapDevices = [];

    boot.kernelPackages = pkgs.linuxPackages_latest;

    system.stateVersion = "22.05";
  };
}
