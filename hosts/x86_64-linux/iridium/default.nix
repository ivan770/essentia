{
  inputs,
  nixosModules,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-laptop-acpi_call
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    nixosModules.users.ivan770
    nixosModules.desktop.generic
    nixosModules.desktop.sway
    nixosModules.hardware.backlight
    nixosModules.hardware.bluetooth
    nixosModules.hardware.firmware
    nixosModules.hardware.networking
    nixosModules.hardware.sound
    nixosModules.hardware.systemd-boot
    nixosModules.hardware.tpm
  ];

  config = {
    essentia = {
      home-manager.profiles = {
        ivan770 = "devunit";
      };
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
