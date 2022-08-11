{ lib, config, pkgs, self-overlay, ... }:

let
  cfg = config.essentia.plymouth;
in
with lib; {
  options.essentia.plymouth = {
    enable = mkEnableOption "Activate Plymouth boot screen";
    theme = mkOption {
      type = types.str;
      default = "bgrt";
      description = "Plymouth theme to be used";
      example = "owl";
    };
  };

  config = mkIf cfg.enable {
    boot.plymouth = {
      enable = true;
      theme = cfg.theme;
    };
  };
}
