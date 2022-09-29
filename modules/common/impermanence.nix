{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.essentia.impermanence;
in
  with lib; {
    options.essentia.impermanence = {
      persistentDirectory = mkOption {
        type = types.str;
        description = "Directory that will be used to store persistent files";
      };

      users = mkOption {
        type = types.attrs;
        default = {};
        description = "User-specific persistence configuration";
      };
    };

    imports = [
      inputs.impermanence.nixosModules.impermanence
    ];

    config = {
      # sops-nix executes secretsForUsers before impermanence module activation,
      # leading to incorrect user password provision on startup.
      # To fix this behaviour, host keys can be simply moved to persistent directory explicitly.
      services.openssh.hostKeys = mkIf config.services.openssh.enable [
        {
          bits = 4096;
          path = "${cfg.persistentDirectory}/etc/ssh/ssh_host_rsa_key";
          type = "rsa";
        }
        {
          path = "${cfg.persistentDirectory}/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];

      # Coredumps are unused in this configuration anyway.
      systemd.coredump.extraConfig = ''
        Storage=none
      '';

      environment.persistence.${cfg.persistentDirectory} = {
        hideMounts = true;

        directories = [
          "/var/lib/bluetooth"
          "/var/lib/logrotate.status"
          "/var/lib/nixos"
          "/var/lib/systemd"
          "/var/log"

          # /var/tmp implies a temporary file on a... persistent storage?
          "/var/tmp"
        ];

        files = [
          "/etc/machine-id"
        ];

        users = cfg.users;
      };
    };
  }
