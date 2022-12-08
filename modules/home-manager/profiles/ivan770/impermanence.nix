{lib, ...}:
with lib; {
  essentia.home-impermanence = {
    directories = mkOptionDefault [
      # .*
      ".cargo"
      ".julia"
      ".rustup"

      # .config/*
      {
        directory = ".config/VirtualBox";
        mode = "0700";
      }

      # Personal directories
      "Config"
      "Documents"
      "Downloads"
      "Music"
      "Pictures"
      "Public"
      "Templates"
      "Videos"
    ];
  };
}
