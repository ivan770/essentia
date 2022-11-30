# The whole file is derived from https://github.com/nix-community/home-manager/blob/master/modules/programs/vscode.nix
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.essentia.programs.code-server;

  jsonFormat = pkgs.formats.json {};

  codeServerDir = "${config.xdg.dataHome}/code-server";
  userDir = "${codeServerDir}/User";

  configFilePath = "${userDir}/settings.json";
  keybindingsFilePath = "${userDir}/keybindings.json";
  extensionPath = "${codeServerDir}/extensions";
in
  with lib; {
    options.essentia.programs.code-server = {
      settings = mkOption {
        type = jsonFormat.type;
        default = {};
        description = "Code Server settings.json file contents";
      };
      keybindings = mkOption {
        type = types.listOf (types.submodule {
          options = {
            key = mkOption {
              type = types.str;
              example = "ctrl+c";
              description = "The key or key-combination to bind.";
            };

            command = mkOption {
              type = types.str;
              example = "editor.action.clipboardCopyAction";
              description = "The VS Code command to execute.";
            };

            when = mkOption {
              type = types.nullOr (types.str);
              default = null;
              example = "textInputFocus";
              description = "Optional context filter.";
            };

            # https://code.visualstudio.com/docs/getstarted/keybindings#_command-arguments
            args = mkOption {
              type = types.nullOr (jsonFormat.type);
              default = null;
              example = {direction = "up";};
              description = "Optional arguments for a command.";
            };
          };
        });
        default = [];
        example = literalExpression ''
          [
            {
              key = "ctrl+c";
              command = "editor.action.clipboardCopyAction";
              when = "textInputFocus";
            }
          ]
        '';
        description = ''
          Code Server keybindings.json file contents
        '';
      };
      extensions = mkOption {
        type = types.listOf types.package;
        default = [];
        description = "Code Server extensions to install";
      };
    };

    config.home.file = mkMerge [
      (mkIf (cfg.settings != {}) {
        "${configFilePath}".source = jsonFormat.generate "code-server-user-settings" cfg.settings;
      })
      (mkIf (cfg.keybindings != []) (let
        dropNullFields = filterAttrs (_: v: v != null);
      in {
        "${keybindingsFilePath}".source =
          jsonFormat.generate "code-server-keybindings"
          (map dropNullFields cfg.keybindings);
      }))
      (mkIf (cfg.extensions != []) {
        "${extensionPath}".source = let
          combinedExtensionsDrv = pkgs.buildEnv {
            name = "vscode-extensions";
            paths = cfg.extensions;
          };
        in "${combinedExtensionsDrv}/share/vscode/extensions";
      })
    ];
  }
