{ config, lib, pkgs, ... }:

let
  cfg = config.essentia.programs.locale;
in
with lib; {
  options.essentia.programs.locale = {
    enable = mkEnableOption "Enable locale configuration";

    base = mkOption {
      type = types.str;
      description = "Primary language that is used to display system interface";
    };

    units = mkOption {
      type = types.str;
      description = "Language used to display units";
    };
  };

  config.home.language = mkIf cfg.enable {
    base = cfg.base;
    collate = cfg.base;
    ctype = cfg.base;
    messages = cfg.base;

    address = cfg.units;
    measurement = cfg.units;
    monetary = cfg.units;
    name = cfg.units;
    paper = cfg.units;
    telephone = cfg.units;
    time = cfg.units;
  };
}
