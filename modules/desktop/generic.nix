{nixosModules, ...}: {
  imports = builtins.attrValues {
    inherit (nixosModules.common) home-manager locale nix secrets security ssh systemd-initrd;
    inherit (nixosModules.desktop) console fonts kernel plymouth silent-boot;
  };
}
