{
  config,
  lib,
  ...
}: {
  users.users.ivan770 = {
    isNormalUser = true;
    passwordFile = config.sops.secrets."users/ivan770/password".path;
    extraGroups =
      [
        "video"
        "wheel"
      ]
      ++ lib.optionals config.security.tpm2.enable [config.security.tpm2.tssGroup]
      ++ lib.optionals config.hardware.sane.enable ["scanner" "lp"];
    openssh.authorizedKeys.keys = [
      (builtins.readFile (builtins.fetchurl {
        url = "https://ssh.ivan770.me";
        sha256 = "1gsrc7pc1i6kx4hi5wskq6ml84pb1hcxqnxkb5qllk5pjg86360m";
      }))
    ];
  };

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
    ];
  };
}
