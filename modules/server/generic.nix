{nixosModules, ...}: {
  imports = with nixosModules; [
    common.nix
    common.secrets
    common.security
    common.ssh
  ];
}
