{
  config,
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
  };

  essentia = {
    amd-gpu.enable = true;
    backlight.enable = true;
    bluetooth.enable = true;
    desktop = {
      enable = true;
      sway.enable = true;
      postgresql.enable = true;
    };
    home-manager.profiles.ivan770 = "devunit";
    firmware.cpu.vendor = "amd";
    impermanence.persistentDirectory = "/nix/persist";
    locale = {
      units = "uk_UA.UTF-8";
      timeZone = "Europe/Kyiv";
    };
    networking = {
      dns.preset = "desktop";
      wireless.enable = true;
    };
    sound.enable = true;
    tlp.cpu = {
      ac = "performance";
      bat = "schedutil";
    };
    tpm.enable = true;
    users.activated = ["ivan770"];
  };

  boot = {
    initrd.availableKernelModules = ["nvme" "xhci_pci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];
    kernelModules = ["kvm-amd"];
    kernelPackages = pkgs.linuxPackages_latest;
    blacklistedKernelModules = ["rtw88_8821ce"];
    extraModulePackages = [config.boot.kernelPackages.rtl8821ce];
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

  system.stateVersion = "22.11";
}
