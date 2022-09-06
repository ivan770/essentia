{pkgs, ...}: {
  settings = builtins.readFile ./settings.json;
  keybindings = builtins.readFile ./keybindings.json;
  extensions = with pkgs.vscode-extensions;
    [
      eamodio.gitlens
      golang.go
      matklad.rust-analyzer
      serayuzgur.crates
      tamasfe.even-better-toml
      usernamehw.errorlens
      jnoortheen.nix-ide
    ]
    ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "theme-blackboard";
        publisher = "gerane";
        version = "0.0.5";
        sha256 = "SjWdM+hcDzHl7UclxjYPGY7wesduzyUksEnZmm89Y7M=";
      }
      {
        name = "hexeditor";
        publisher = "ms-vscode";
        version = "1.8.2";
        sha256 = "UwDX7ErNfpEM1FWH7UwtSwPLzzk5t2qpY1g+5h4g04A=";
      }
      {
        name = "direnv";
        publisher = "mkhl";
        version = "0.6.1";
        sha256 = "5/Tqpn/7byl+z2ATflgKV1+rhdqj+XMEZNbGwDmGwLQ=";
      }
      {
        name = "clips-ide";
        publisher = "algono";
        version = "1.2.0";
        sha256 = "Tisq8a498xGXdBQQlw+NoSNEiCVrAzvmwE9X4QL+8V4=";
      }
    ];
}
