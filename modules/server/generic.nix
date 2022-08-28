{nixosModules, ...}: {
  imports = with nixosModules; [
    common.nix
    server.ssh
  ];
}
