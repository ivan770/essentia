{...}: {
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
      ".mozilla"
      {
        directory = ".pki";
        mode = "0700";
      }

      # .config/*
      {
        directory = ".config/dconf";
        mode = "0700";
      }
      ".config/VSCodium"

      # .local/*
      ".local/share/direnv"
      {
        directory = ".local/share/TelegramDesktop";
        mode = "0700";
      }
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
    ];
  };
}
