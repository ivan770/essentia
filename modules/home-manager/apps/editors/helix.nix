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
        type = types.attrs;
        default = {};
        description = "Helix settings";
      };
    };

    config = {
      programs.helix = {
        enable = true;
        settings = cfg.settings;
      };

      essentia.home-impermanence.directories = mkOptionDefault [
        ".cache/helix"
      ];
    };
  }
