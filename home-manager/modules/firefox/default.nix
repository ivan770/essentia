{ config, lib, pkgs, ... }:

let
  cfg = config.essentia.programs.firefox;
in
with lib; {
  options.essentia.programs.firefox = {
    enable = mkEnableOption "Enable Firefox";
    wayland = mkEnableOption "Enable Firefox Wayland support";
  };

  config = mkMerge [
    (mkIf cfg.enable {
      home.packages = [ pkgs.firefox ];
    })
    (mkIf cfg.wayland {
      systemd.user.sessionVariables = {
        MOZ_ENABLE_WAYLAND = 1;
      };
    })
  ];
}
