{
  config,
  lib,
  ...
}: let
  cfg = config.essentia.tlp;

  supportedGovernors = [
    "schedutil"
    "performance"
  ];
in
  with lib; {
    options.essentia.tlp = {
      bluetoothOnStartup = mkEnableOption "automatically enable bluetooth on startup";

      cpu = {
        ac = mkOption {
          type = types.enum supportedGovernors;
          description = "CPU scaling governor to use when connected to AC";
        };

        bat = mkOption {
          type = types.enum supportedGovernors;
          description = "CPU scaling governor to use with battery";
        };
      };
    };

    config.services.tlp = {
      enable = true;
      settings = mkMerge [
        (mkIf (config.hardware.bluetooth.enable && !cfg.bluetoothOnStartup) {
          DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth";
        })
        {
          CPU_SCALING_GOVERNOR_ON_AC = cfg.cpu.ac;
          CPU_SCALING_GOVERNOR_ON_BAT = cfg.cpu.bat;

          CPU_BOOST_ON_AC = 1;
          CPU_BOOST_ON_BAT = 0;
        }
      ];
    };
  }
