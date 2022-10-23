{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.essentia.programs.vscode;
in
  with lib; {
    options.essentia.programs.vscode = {
      settings = mkOption {
        type = types.nullOr types.attrs;
        default = null;
        description = "VS Code settings.json file contents";
      };
      keybindings = mkOption {
        type = types.nullOr (types.listOf types.attrs);
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
        (mkIf (isAttrs cfg.settings) {
          userSettings = cfg.settings;
        })
        (mkIf (isList cfg.keybindings) {
          keybindings = cfg.keybindings;
        })
        (mkIf (cfg.extensions != []) {
          mutableExtensionsDir = false;
          extensions = cfg.extensions;
        })
      ];
    };
  }
