{nixosModules, ...}: {
  imports = with nixosModules; [
    common.home-manager
    common.locale
    common.nix
    common.secrets
    common.security
    common.ssh
    common.user-management
    desktop.console
    desktop.fonts
    desktop.plymouth
    desktop.silent-boot
  ];
}
