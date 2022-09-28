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

      environment.persistence.${cfg.persistentDirectory} = {
        hideMounts = true;

        directories = [
          "/var/log"
        ];

        files = [
          "/etc/machine-id"
        ];
      };
    };
  }
