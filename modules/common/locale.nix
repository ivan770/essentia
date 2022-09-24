{
  config,
  lib,
  ...
}: let
  cfg = config.essentia.locale;
in
  with lib; {
    options.essentia.locale = {
      base = mkOption {
        type = types.str;
        default = "en_US.UTF-8";
        description = "Primary language that is used to display system interface";
      };

      units = mkOption {
        type = types.str;
        default = "en_US.UTF-8";
        description = "Language used to display units";
      };

      timeZone = mkOption {
        type = types.str;
        default = "Etc/UTC";
        description = "Global time zone configuration";
      };

      extendedLocales = mkEnableOption "extended locale support";
    };

    config = {
      i18n = {
        defaultLocale = cfg.base;
        extraLocaleSettings = {
          LC_CTYPE = cfg.base;
          LC_COLLATE = cfg.base;
          LC_NUMERIC = cfg.base;
          LC_MESSAGES = cfg.base;

          LC_ADDRESS = cfg.units;
          LC_MEASUREMENT = cfg.units;
          LC_MONETARY = cfg.units;
          LC_NAME = cfg.units;
          LC_PAPER = cfg.units;
          LC_TELEPHONE = cfg.units;
          LC_TIME = cfg.units;
        };

        supportedLocales =
          [
            "en_US.UTF-8/UTF-8"
          ]
          ++ optionals cfg.extendedLocales [
            "uk_UA.UTF-8/UTF-8"
            "ru_UA.UTF-8/UTF-8"
          ];
      };
      time.timeZone = cfg.timeZone;
    };
  }
