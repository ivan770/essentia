{ config, lib, pkgs, ... }:

let
  cfg = config.essentia.programs.qbittorrent;
in
with lib; {
  options.essentia.programs.qbittorrent = {
    enable = mkEnableOption "Enable qBittorrent";
    installConfig = mkEnableOption "Install qBittorrent configuration";
  };

  config = mkMerge [
    (mkIf cfg.enable {
      home.packages = [ pkgs.qbittorrent ];
    })
    (mkIf cfg.installConfig {
      xdg.configFile."qBittorrent/qBittorrent.conf".text = builtins.readFile ./config.conf;
    })
  ];
}
