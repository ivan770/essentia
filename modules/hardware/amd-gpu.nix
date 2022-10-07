{inputs, ...}: {
  imports = builtins.attrValues {
    inherit (inputs.nixos-hardware.nixosModules) common-gpu-amd;
  };

  hardware.opengl.enable = true;
}
