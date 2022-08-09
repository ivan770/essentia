{ config, lib, ... }:

let
  cfg = config.essentia.locale;
in
with lib; {
  options.essentia.locale = {
    enable = mkEnableOption "Activate locale configuration";
  };

  config = mkIf cfg.enable {
    i18n.defaultLocale = "en_US.UTF-8";

    time.timeZone = "Europe/Kiev";

    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
    };
  };
}
