{
  lib,
  pkgs,
  ...
}: {
  settings = import ./settings.nix {inherit lib;};
  extensions = with pkgs.vscode-extensions;
    [
      eamodio.gitlens
      golang.go
      matklad.rust-analyzer
      serayuzgur.crates
      tamasfe.even-better-toml
      usernamehw.errorlens
      jnoortheen.nix-ide
      mkhl.direnv
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
        name = "hexeditor";
        publisher = "ms-vscode";
        version = "1.9.9";
        sha256 = "azUd4e1AHpPMhb+nXRqTzb3W/Z0RvZLn/fSa+ihN63A=";
      }
      {
        name = "clips-ide";
        publisher = "algono";
        version = "1.2.0";
        sha256 = "Tisq8a498xGXdBQQlw+NoSNEiCVrAzvmwE9X4QL+8V4=";
      }
      {
        name = "clips-lang";
        publisher = "nerg";
        version = "1.0.2";
        sha256 = "aTvvzGsFVAvDWUl7kaOS6O0OVhTgCG4g0s02CiM4THE=";
      }
      {
        name = "language-julia";
        publisher = "julialang";
        version = "1.7.12";
        sha256 = "g6os6ktSWzUSCnLzMkGRoOhCEvU3gXcGGj2cq1NKkaE=";
      }
    ];
}
