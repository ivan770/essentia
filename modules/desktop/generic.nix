{nixosModules, ...}: {
  imports = builtins.attrValues {
    inherit (nixosModules.common) documentation home-manager locale nix secrets security ssh;
    inherit (nixosModules.desktop) console fonts kernel plymouth silent-boot;
  };
}
