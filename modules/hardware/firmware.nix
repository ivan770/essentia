{
  config,
  lib,
  ...
}: let
  cfg = config.essentia.firmware;
in
  with lib; {
    options.essentia.firmware = {
      cpu.vendor = mkOption {
        type = types.enum ["amd" "intel"];
        description = "CPU vendor";
        example = "amd";
      };
    };

    config.hardware = {
      enableRedistributableFirmware = true;
      cpu.${cfg.cpu.vendor}.updateMicrocode = true;
    };
  }
