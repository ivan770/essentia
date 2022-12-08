{
  lib,
  pkgs,
  ...
}:
with lib; {
  home.packages = [pkgs.steam];

  essentia.home-impermanence.directories = mkOptionDefault [
    ".steam"
    {
      directory = ".local/share/Steam";
      mode = "0700";
    }
    ".local/share/vulkan"
  ];
}
