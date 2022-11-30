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

      timeout = mkOption {
        type = types.int;
        default = 0;
        description = "Bootloader entry selection screen timeout";
        example = 5;
      };
    };

    config.boot.loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = cfg.mountpoint;
      };
      systemd-boot = {
        enable = true;
        editor = false;
        configurationLimit = 5;
        consoleMode = "max";
      };
      timeout = cfg.timeout;
    };
  }
