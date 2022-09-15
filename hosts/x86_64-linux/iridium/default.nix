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

    inherit (nixosModules.users) ivan770;
    inherit (nixosModules.desktop) generic sway;
    inherit
      (nixosModules.hardware)
      backlight
      bluetooth
      firmware
      networking
      sound
      systemd-boot
      tpm
      ;
  };

  config = {
    essentia = {
      home-manager.profiles.ivan770 = "devunit";
      firmware.cpu.vendor = "amd";
      locale = {
        base = "en_US.UTF-8";
        units = "uk_UA.UTF-8";
        timeZone = "Europe/Kiev";
      };
      networking = {
        wireless = [
          "default_5g"
        ];
        desktopDns = true;
      };
    };

    boot = {
      initrd.availableKernelModules = ["nvme" "xhci_pci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];
      kernelModules = ["kvm-amd"];
    };

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/4e1bd269-67b9-48cb-95ea-bbcfd6b7f578";
      fsType = "ext4";
      options = [
        "noatime"
        "commit=60"
      ];
    };

    fileSystems."/boot/efi" = {
      device = "/dev/disk/by-uuid/4CEC-FA37";
      fsType = "vfat";
    };

    swapDevices = [
      {device = "/dev/disk/by-uuid/72c3245b-b368-4b1c-9be7-b29ce9451a93";}
    ];

    boot.kernelPackages = pkgs.linuxPackages_latest;

    system.stateVersion = "22.05";
  };
}
