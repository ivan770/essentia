{
  lib,
  pkgs,
  ...
}:
with lib; {
  home.packages = [pkgs.lunar-client];

  essentia.home-impermanence.directories = mkOptionDefault [
    ".java"
    ".lunarclient"
    ".minecraft"
    ".config/lunarclient"
  ];
}
