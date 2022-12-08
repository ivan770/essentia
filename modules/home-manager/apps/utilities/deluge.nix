{
  lib,
  pkgs,
  ...
}:
with lib; {
  home.packages = [pkgs.deluge];

  essentia.home-impermanence.directories = mkOptionDefault [
    {
      directory = ".config/deluge";
      mode = "0700";
    }
  ];
}
