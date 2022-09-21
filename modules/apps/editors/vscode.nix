{
  config,
  lib,
  pkgs,
  fromJSONWithComments,
  ...
}: let
  cfg = config.essentia.programs.vscode;
in
  with lib; {
    options.essentia.programs.vscode = {
      settings = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "VS Code settings.json file contents";
      };
      keybindings = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "VS Code keybindings.json file contents";
      };
      extensions = mkOption {
        type = types.listOf types.package;
        default = [];
        description = "VS Code extensions to install";
      };
    };

    config = {
      programs.vscode = mkMerge [
        {
          enable = true;
          package = pkgs.vscodium;
        }
        (mkIf (isString cfg.settings) {
          userSettings = fromJSONWithComments cfg.settings;
        })
        (mkIf (isString cfg.keybindings) {
          keybindings = fromJSONWithComments cfg.keybindings;
        })
        (mkIf (cfg.extensions != []) {
          mutableExtensionsDir = false;
          extensions = cfg.extensions;
        })
      ];
    };
  }
