{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.essentia.locale;
in
  with lib; {
    options.essentia.locale = {
      base = mkOption {
        type = types.str;
        description = "Primary language that is used to display system interface";
      };

      units = mkOption {
        type = types.str;
        description = "Language used to display units";
      };

      timeZone = mkOption {
        type = types.str;
        description = "Global time zone configuration";
      };

      supportedLocales = mkOption {
        type = types.listOf types.str;
        description = "Locales for glibc to support";
        default = [
          "en_US.UTF-8/UTF-8"
          "uk_UA.UTF-8/UTF-8"
          "ru_UA.UTF-8/UTF-8"
        ];
      };
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
        supportedLocales = cfg.supportedLocales;
      };
      time.timeZone = cfg.timeZone;
    };
  }
