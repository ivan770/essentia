{
  lib,
  config,
  ...
}: let
  cfg = config.essentia.systemd-boot;
in
  with lib; {
    options.essentia.systemd-boot = {
      mountpoint = mkOption {
        type = types.str;
        default = "/boot/efi";
        description = "Bootloader mountpoint";
        example = "/boot";
      };
    };

    config.boot.loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = cfg.mountpoint;
      };
      systemd-boot = {
        enable = true;
        editor = true; # Temp
        configurationLimit = 5;
        consoleMode = "max";
      };
      timeout = 2;
    };
  }
