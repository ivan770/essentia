# The whole file is derived from https://github.com/nix-community/home-manager/blob/master/modules/programs/vscode.nix
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.essentia.programs.code-server;

  jsonFormat = pkgs.formats.json {};

  codeServerDir = "${xdg.dataHome}/code-server";
  userDir = "${codeServerDir}/User";

  configFilePath = "${userDir}/settings.json";
  keybindingsFilePath = "${userDir}/keybindings.json";
  extensionPath = "${codeServerDir}/extensions";
in
  with lib; {
    options.essentia.programs.code-server = {
      settings = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Code Server settings.json file contents";
      };
      keybindings = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Code Server keybindings.json file contents";
      };
      extensions = mkOption {
        type = types.listOf types.package;
        default = [];
        description = "Code Server extensions to install";
      };
    };

    config = mkMerge [
      (mkIf (isString cfg.settings) {
        "${configFilePath}".text = cfg.settings;
      })
      (mkIf (isString cfg.keybindings) {
        "${keybindingsFilePath}".text = cfg.keybindings;
      })
      (mkIf (cfg.extensions != []) (let
        subDir = "share/vscode/extensions";

        # Adapted from https://discourse.nixos.org/t/vscode-extensions-setup/1801/2
        toPaths = ext:
          map (k: {"${extensionPath}/${k}".source = "${ext}/${subDir}/${k}";})
          (
            if ext ? vscodeExtUniqueId
            then [ext.vscodeExtUniqueId]
            else builtins.attrNames (builtins.readDir (ext + "/${subDir}"))
          );
      in {
        "${extensionPath}".source = let
          combinedExtensionsDrv = pkgs.buildEnv {
            name = "vscode-extensions";
            paths = cfg.extensions;
          };
        in "${combinedExtensionsDrv}/${subDir}";
      }))
    ];
  }
