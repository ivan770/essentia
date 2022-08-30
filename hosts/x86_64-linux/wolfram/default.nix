{
  inputs,
  nixosModules,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-hdd
    nixosModules.users.ivan770
    nixosModules.desktop.generic
    nixosModules.desktop.gnome
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
      locale = {
        base = "en_US.UTF-8";
        units = "uk_UA.UTF-8";
        timeZone = "Europe/Kiev";
      };
      networking = {
        wired = true;
        dnsOverTls = true;
      };
    };

    hardware.enableRedistributableFirmware = true;

    boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

    system.stateVersion = "22.05";
  };
}
