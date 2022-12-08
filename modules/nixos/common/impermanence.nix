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
        type = types.nullOr types.str;
        default = null;
        description = "Directory that will be used to store persistent files";
      };

      users = mkOption {
        type = types.attrs;
        default = {};
        description = "User-specific persistence configuration";
      };

      persistentJournald = mkEnableOption "persistent journald logs";
    };

    imports = [
      inputs.impermanence.nixosModules.impermanence
    ];

    config = mkIf (isString cfg.persistentDirectory) {
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

      services.journald.extraConfig = mkIf (!cfg.persistentJournald) ''
        Storage=volatile
      '';

      environment.persistence.${cfg.persistentDirectory} = {
        hideMounts = true;

        directories = [
          "/var/lib/nixos"
          # FIXME: Refactor the entire impermanence module as soon as https://github.com/nix-community/impermanence/pull/109 gets merged
          (mkIf
            (hasAttr "hedgedoc" config.essentia.server.containers.activatedConfigurations)
            "/var/lib/hedgedoc-data")
          {
            directory = "/var/lib/bluetooth";
            mode = "0700";
          }
          "/var/lib/cups"
          (mkIf config.services.postgresql.enable {
            directory = "/var/lib/postgresql";
            mode = "0750";
            user = config.users.users.postgres.name;
            group = config.users.users.postgres.group;
          })
          "/var/lib/systemd"
          "/var/log"

          # /var/tmp implies a temporary file on a... persistent storage?
          {
            directory = "/var/tmp";
            mode = "0777";
          }
        ];

        files = [
          "/etc/machine-id"
          "/var/lib/logrotate.status"
        ];

        users = cfg.users;
      };
    };
  }
