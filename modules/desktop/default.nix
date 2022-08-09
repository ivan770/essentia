{ lib, pkgs, config, inputs, ... }:

let
  cfg = config.essentia.desktop;
in
with lib; {
  options.essentia.desktop = {
    enable = mkEnableOption "Enable the desktop configuration";
    home-manager = mkEnableOption "Activate home-manager";
  };

  config = mkIf cfg.enable {
    essentia = {
      common.enable = true;
      user.ivan770.enable = true;
      home-manager = mkIf cfg.home-manager {
        enable = true;
        profile = "battlestation";
      };
      locale.enable = true;
      gnome.enable = true;
    };
  };
}
