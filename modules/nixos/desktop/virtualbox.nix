{
  config,
  lib,
  ...
}: let
  cfg = config.essentia.desktop.virtualbox;
in
  with lib; {
    options.essentia.desktop.virtualbox = {
      enable = mkEnableOption "VirtualBox support";
    };

    config.virtualisation.virtualbox.host = mkIf cfg.enable {
      enable = true;
    };
  }
