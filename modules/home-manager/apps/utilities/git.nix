{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.essentia.programs.git;
in
  with lib; {
    options.essentia.programs.git = {
      credentials = mkOption {
        type = types.path;
        description = "Path to Git credentials, provided as an additional configuration";
      };
    };

    config.programs.git = {
      enable = true;
      package = pkgs.gitMinimal;
      signing = {
        signByDefault = true;
        key = null;
      };
      includes = [
        {path = cfg.credentials;}
      ];
      difftastic = {
        enable = true;
        color = "always";
      };
    };
  }
