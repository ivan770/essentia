{nixosModules, ...}: {
  imports = with nixosModules; [
    common.home-manager
    common.locale
    common.nix
    desktop.console
    desktop.fonts
    desktop.plymouth
    desktop.silent-boot
  ];
}
