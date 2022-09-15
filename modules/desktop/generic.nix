{nixosModules, ...}: {
  imports = with nixosModules; [
    common.home-manager
    common.locale
    common.nix
    common.secrets
    common.security
    common.ssh
    desktop.console
    desktop.fonts
    desktop.kernel
    desktop.plymouth
    desktop.silent-boot
  ];
}
