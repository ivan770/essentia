{
  lib,
  pkgs,
  ...
}:
with lib; {
  home.packages = [pkgs.tdesktop];

  essentia.home-impermanence.directories = mkOptionDefault [
    {
      directory = ".local/share/TelegramDesktop";
      mode = "0700";
    }
  ];
}
