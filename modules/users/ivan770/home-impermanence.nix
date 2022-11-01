{
  essentia.impermanence.users.ivan770 = {
    directories = [
      # .*
      {
        directory = ".cache";
        mode = "0700";
      }
      {
        directory = ".gnupg";
        mode = "0700";
      }
      ".java"
      ".julia"
      ".lunarclient"
      ".minecraft"
      ".mozilla"
      {
        directory = ".pki";
        mode = "0700";
      }
      ".steam"

      # .config/*
      {
        directory = ".config/dconf";
        mode = "0700";
      }
      ".config/discord"
      ".config/lunarclient"
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
      {
        directory = ".local/state/wireplumber";
        mode = "0700";
      }

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

    files = [
      ".bash_history"
      {
        file = ".ssh/known_hosts";
        parentDirectory = {mode = "0700";};
      }
      ".packettracer"
    ];
  };
}
