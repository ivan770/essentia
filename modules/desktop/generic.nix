{nixosModules, ...}: {
  imports = with nixosModules; [
    common.home-manager
    common.locale
    common.nix
    desktop.fonts
    desktop.kmscon
    desktop.plymouth
    desktop.silent-boot
  ];
}
