{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.essentia.postgresql;
in
  with lib; {
    options.essentia.postgresql = {
      serverConfig = mkOption {
        type = with types; attrsOf (oneOf [bool float int str]);
        default = {};
        description = "Server-specific PostgreSQL configuration.";
      };
    };

    config.services.postgresql = {
      enable = true;
      package = pkgs.postgresql_14;
      enableTCPIP = true;
      settings =
        cfg.serverConfig
        // {
          ssl = true;
          ssl_cert_file = config.sops.secrets."postgresql/ssl/server/cert".path;
          ssl_key_file = config.sops.secrets."postgresql/ssl/server/key".path;
          ssl_ca_file = config.sops.secrets."postgresql/ssl/root".path;
        };
      authentication = ''
        hostssl all all 0.0.0.0/0 cert clientcert=verify-full
      '';
      ensureUsers = [
        {
          # FIXME: Hardcoded for now
          name = "ivan770";
          ensurePermissions = {
            "ALL TABLES IN SCHEMA public" = "ALL PRIVILEGES";
          };
        }
      ];
    };
  }
