{ lib, config, ... }:

let
  cfg = config.essentia.grub-efi;
in
with lib; {
  options.essentia.grub-efi = {
    enable = mkEnableOption "Activate GRUB2 support";

    mountpoint = mkOption {
      type = types.str;
      default = "/boot/efi";
      description = "Bootloader mountpoint";
      example = "/boot";
    };
  };

  config = mkIf cfg.enable {
    boot.loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = cfg.mountpoint;
      };
      grub = {
        enable = true;
        version = 2;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
      };
    };
  };
}
