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
        type = types.nullOr types.path;
        default = null;
        description = "qBittorrent settings file contents";
      };
    };

    config = mkMerge [
      {
        home.packages = [
          (pkgs.qbittorrent.override {
            webuiSupport = false;
            trackerSearch = false;
          })
        ];
      }
      (mkIf (builtins.isPath cfg.settings) {
        home.activation.qBittorrent = lib.hm.dag.entryAfter ["writeBoundary"] ''
          $DRY_RUN_CMD cp $VERBOSE_ARG \
              ${cfg.settings} ${config.xdg.configHome}/qBittorrent/qBittorrent.conf
        '';
      })
    ];
  }
