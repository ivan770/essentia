{lib, ...}:
with lib; {
  essentia.home-impermanence = {
    directories = mkOptionDefault [
      # .*
      ".cargo"
      {
        directory = ".gnupg";
        mode = "0700";
      }
      ".java"
      ".julia"
      ".lunarclient"
      ".minecraft"
      ".mozilla"
      ".rustup"
      ".steam"

      # .config/*
      {
        directory = ".config/deluge";
        mode = "0700";
      }
      ".config/discord"
      ".config/lunarclient"
      {
        directory = ".config/VirtualBox";
        mode = "0700";
      }
      ".config/VSCodium"

      # .local/*
      {
        directory = ".local/share/Cisco Packet Tracer";
        mode = "0700";
      }
      ".local/share/direnv"
      ".local/share/jupyter"
      {
        directory = ".local/share/Steam";
        mode = "0700";
      }
      {
        directory = ".local/share/TelegramDesktop";
        mode = "0700";
      }
      ".local/share/vulkan"

      # Personal directories
      "Config"
      "Documents"
      "Downloads"
      "Music"
      "Pictures"
      # Cisco Packet Tracer data directory
      "pt"
      "Public"
      "Templates"
      "Videos"
    ];

    files = mkOptionDefault [
      ".packettracer"
    ];
  };
}
