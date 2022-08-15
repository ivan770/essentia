{ config, lib, pkgs, ... }:

let
  cfg = config.essentia.programs.discord;
in
with lib; {
  options.essentia.programs.discord = {
    settings = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Discord settings file contents";
    };
  };

  config = mkMerge [
    {
      home.packages = [ pkgs.discord ];
    }
    (mkIf (isString cfg.settings) {
      xdg.configFile."discord/settings.json".text = cfg.settings;
    })
  ];
}
