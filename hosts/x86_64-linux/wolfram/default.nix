{
  inputs,
  nixosModules,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-hdd
    nixosModules.users.ivan770
    nixosModules.desktop.generic
    nixosModules.desktop.gnome
    nixosModules.hardware.firmware
    nixosModules.hardware.networking
    nixosModules.hardware.nvidia
    nixosModules.hardware.printing
    nixosModules.hardware.sound
    nixosModules.hardware.systemd-boot
    nixosModules.hardware.tpm
    # Required to enable Lunar Client via Flatpak.
    # Nixpkgs' version of Lunar is extremely outdated and isn't working properly
    #
    # In case if you want to disable Flatpak, ensure to completely remove leftover files
    # via flatpak uninstall --all
    # https://discourse.flathub.org/t/how-to-completely-uninstall-any-flatpak-app-on-ubuntu/709
    nixosModules.apps.games.flatpak
    nixosModules.apps.games.gamemode
    nixosModules.apps.games.steam
  ];

  config = {
    essentia = {
      home-manager.profiles.ivan770 = "battlestation";
      firmware.cpu.vendor = "amd";
      locale = {
        base = "en_US.UTF-8";
        units = "uk_UA.UTF-8";
        timeZone = "Europe/Kiev";
      };
      networking = {
        wired = true;
        desktopDns = true;
      };
      secrets.psqlSecrets = true;
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
