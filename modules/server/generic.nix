{nixosModules, ...}: {
  imports = with nixosModules; [
    common.nix
    common.user-management
    common.secrets
    common.security
    common.ssh
  ];
}
