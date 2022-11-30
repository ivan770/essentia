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

      cpu = mkOption {
        type = types.nullOr (types.submodule {
          options = {
            ac = mkOption {
              type = types.enum supportedGovernors;
              description = ''
                CPU scaling governor to use when connected to AC.
              '';
            };

            bat = mkOption {
              type = types.enum supportedGovernors;
              description = ''
                CPU scaling governor to use with battery.
              '';
            };
          };
        });
        default = null;
        description = ''
          TLP CPU governor configuration.
        '';
      };
    };

    config.services.tlp = mkIf (cfg.cpu != null) {
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
