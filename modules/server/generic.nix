{nixosModules, ...}: {
  imports = builtins.attrValues {
    inherit (nixosModules.common) nix secrets security ssh;
    inherit (nixosModules.server) firewall;
  };
}
