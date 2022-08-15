{
  config,
  lib,
  ...
}: let
  cfg = config.essentia.programs.helix;
in
  with lib; {
    options.essentia.programs.helix = {
      settings = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Helix settings file contents";
      };
    };

    config.programs.helix = mkMerge [
      {
        enable = true;
      }
      (mkIf (isString cfg.settings) {
        settings = builtins.fromTOML cfg.settings;
      })
    ];
  }
