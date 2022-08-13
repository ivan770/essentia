{ lib, config, ... }:

let
  cfg = config.essentia.grub-efi;
in
with lib; {
  options.essentia.grub-efi = {
    mountpoint = mkOption {
      type = types.str;
      default = "/boot/efi";
      description = "Bootloader mountpoint";
      example = "/boot";
    };

    gfxmode = mkOption {
      type = types.str;
      default = "1024x768";
      description = "gfxmode value to pass to GRUB";
      example = "1920x1080";
    };
  };

  config.boot.loader = {
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
      gfxmodeEfi = cfg.gfxmode;
    };
  };
}
