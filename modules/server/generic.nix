{nixosModules, ...}: {
  imports = builtins.attrValues {
    inherit (nixosModules.common) documentation locale nix secrets security ssh systemd-initrd;
    inherit (nixosModules.server) firewall kernel;
  };
}
