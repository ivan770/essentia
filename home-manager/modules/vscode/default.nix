{ config, lib, pkgs, ... }:

let
  cfg = config.essentia.programs.vscode;
in
with lib; {
  options.essentia.programs.vscode = {
    enable = mkEnableOption "Enable VS Code";
    installConfig = mkEnableOption "Install VS Code configuration";
    installExtensions = mkEnableOption "Install VS Code extensions";
  };

  config = mkIf cfg.enable {
    programs.vscode = mkMerge [
      {
        enable = true;
        package = pkgs.vscode;
      }
      (mkIf cfg.installConfig {
        # Since vscode.json contains comments, we have to filter them out before building up JSON value.
        userSettings =
          let
            lines = strings.splitString "\n" (builtins.readFile ./vscode.json);
          in
          builtins.fromJSON (strings.concatStrings (filter
            (line: !hasPrefix "//" (
              strings.concatStrings (filter (line: line != " ") (strings.stringToCharacters line))
            ))
            lines));
      })
      (mkIf cfg.installExtensions {
        mutableExtensionsDir = false;
        extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "gitlens";
            publisher = "eamodio";
            version = "12.1.2";
            sha256 = "qclBbZeGH7ODYAruhTi7X5FTRcai29nGTpSbeF129XI=";
          }
          {
            name = "theme-blackboard";
            publisher = "gerane";
            version = "0.0.5";
            sha256 = "SjWdM+hcDzHl7UclxjYPGY7wesduzyUksEnZmm89Y7M=";
          }
          {
            name = "go";
            publisher = "golang";
            version = "0.33.1";
            sha256 = "LyQHaTJ39meZ4R0QzzFVsJelO/S5EPdXCxyyRoDuUjc=";
          }
          {
            name = "rust-analyzer";
            publisher = "rust-lang";
            version = "0.4.1161";
            sha256 = "7WwWRf19UxenH1xNUZqt2uasjo2DfUZvtD7Fw1T8IjQ=";
          }
          {
            name = "remote-ssh";
            publisher = "ms-vscode-remote";
            version = "0.68.0";
            sha256 = "FAX/P7QJuRqe1obkP/K0Ho1tlADw4yAnkU9dI7xrHlY=";
          }
          {
            name = "remote-ssh-edit";
            publisher = "ms-vscode-remote";
            version = "0.68.0";
            sha256 = "FwykWD1WVNTgeaKAxR7HKOugjdJHBoNOB1aZ9auS4Fc=";
          }
          {
            name = "hexeditor";
            publisher = "ms-vscode";
            version = "1.8.2";
            sha256 = "UwDX7ErNfpEM1FWH7UwtSwPLzzk5t2qpY1g+5h4g04A=";
          }
          {
            name = "crates";
            publisher = "serayuzgur";
            version = "0.5.10";
            sha256 = "bY/dphiEPPgTg1zMjvxx4b0Ska2XggRucnZxtbppcLU=";
          }
          {
            name = "even-better-toml";
            publisher = "tamasfe";
            version = "0.14.2";
            sha256 = "lE2t+KUfClD/xjpvexTJlEr7Kufo+22DUM9Ju4Tisp0=";
          }
          {
            name = "errorlens";
            publisher = "usernamehw";
            version = "3.4.1";
            sha256 = "cJ1/jfCU+Agiyi1Qdd0AfyOTzwxOEfox4vLSJ0/UKNc=";
          }
          {
            name = "nix-ide";
            publisher = "jnoortheen";
            version = "0.1.20";
            sha256 = "Q6X41I68m0jaCXaQGEFOoAbSUrr/wFhfCH5KrduOtZo=";
          }
        ];
      })
    ];
  };
}
