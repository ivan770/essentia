{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.essentia.plymouth;
in
  with lib; {
    options.essentia.plymouth = {
      theme = mkOption {
        type = types.str;
        default = "bgrt";
        description = "Plymouth theme to be used";
        example = "owl";
      };
    };

    config.boot.plymouth = {
      enable = true;
      theme = cfg.theme;
    };
  }
