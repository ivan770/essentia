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
        type = types.nullOr (types.enum ["amd" "intel"]);
        description = "CPU vendor";
        example = "amd";
      };
    };

    config.hardware = mkMerge [
      {
        enableRedistributableFirmware = true;
      }
      (mkIf (isString cfg.cpu.vendor) {
        cpu.${cfg.cpu.vendor}.updateMicrocode = true;
      })
    ];
  }
