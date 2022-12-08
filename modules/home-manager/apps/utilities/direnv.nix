{lib, ...}:
with lib; {
  programs.direnv = {
    enable = true;
    enableFishIntegration = false;
    enableZshIntegration = false;
    nix-direnv.enable = true;
  };

  essentia.home-impermanence.directories = mkOptionDefault [
    ".local/share/direnv"
  ];
}
