{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.essentia.programs.qbittorrent;
in
  with lib; {
    options.essentia.programs.qbittorrent = {
      settings = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "qBittorrent settings file contents";
      };
    };

    config = mkMerge [
      {
        home.packages = [pkgs.qbittorrent];
      }
      (mkIf (isString cfg.settings) {
        xdg.configFile."qBittorrent/qBittorrent.conf".text = cfg.settings;
      })
    ];
  }
