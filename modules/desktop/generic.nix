{nixosModules, ...}: {
  imports = with nixosModules; [
    common.home-manager
    common.locale
    common.nix
    desktop.fonts
    desktop.plymouth
    hardware.sound
  ];
}
