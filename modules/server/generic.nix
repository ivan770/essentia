{nixosModules, ...}: {
  imports = builtins.attrValues {
    inherit (nixosModules.common) locale nix secrets security ssh;
    inherit (nixosModules.server) firewall kernel;
  };
}
