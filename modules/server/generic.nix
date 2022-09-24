{nixosModules, ...}: {
  imports = builtins.attrValues {
    inherit (nixosModules.common) locale nix secrets security ssh systemd-initrd;
    inherit (nixosModules.server) firewall kernel;
  };
}
