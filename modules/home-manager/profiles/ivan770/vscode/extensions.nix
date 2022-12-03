{pkgs, ...}:
with pkgs.vscode-extensions;
  [
    mkhl.direnv
    eamodio.gitlens
    usernamehw.errorlens
    ms-vscode.hexeditor

    matklad.rust-analyzer
    serayuzgur.crates
    tamasfe.even-better-toml

    jnoortheen.nix-ide

    ms-toolsai.jupyter
  ]
  ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "theme-blackboard";
      publisher = "gerane";
      version = "0.0.5";
      sha256 = "SjWdM+hcDzHl7UclxjYPGY7wesduzyUksEnZmm89Y7M=";
    }
    {
      name = "language-julia";
      publisher = "julialang";
      version = "1.7.12";
      sha256 = "g6os6ktSWzUSCnLzMkGRoOhCEvU3gXcGGj2cq1NKkaE=";
    }
  ]
