{
  lib,
  config,
  ...
}: let
  cfg = config.essentia.secrets;
in
  with lib; {
    options.essentia.secrets = {
      psqlSecrets = mkEnableOption "psql secrets needed for PostgreSQL client authentication";
      postgresqlSecrets = mkEnableOption "PostgreSQL secrets needed for client authentication";
      ssl = mkEnableOption "ssl secrets needed for nginx";
    };

    config = {
      assertions = [
        {
          assertion = !(cfg.psqlSecrets && cfg.postgresqlSecrets);
          message = "Activating both psqlSecrets and postgresqlSecrets is currently unsupported";
        }
      ];

      sops = {
        defaultSopsFile = ../../secrets.yaml;
        secrets = mkMerge [
          {
            "users/ivan770/password".neededForUsers = true;
            "users/ivan770/git" = {
              owner = config.users.users.ivan770.name;
              group = config.users.users.ivan770.group;
            };
            networks = {};
            trusted_networks = {};
          }
          (mkIf cfg.ssl {
            "ssl/cert" = {
              owner = config.services.nginx.user;
              group = config.services.nginx.group;
            };
            "ssl/key" = {
              owner = config.services.nginx.user;
              group = config.services.nginx.group;
            };
          })
          (mkIf cfg.psqlSecrets {
            "users/ivan770/postgresql/cert" = {
              owner = config.users.users.ivan770.name;
              group = config.users.users.ivan770.group;
            };
            "users/ivan770/postgresql/key" = {
              owner = config.users.users.ivan770.name;
              group = config.users.users.ivan770.group;
            };
            "postgresql/ssl/root" = {
              owner = config.users.users.ivan770.name;
              group = config.users.users.ivan770.group;
            };
          })
          (mkIf cfg.postgresqlSecrets {
            "postgresql/ssl/server/cert" = {
              owner = "postgres";
              group = "postgres";
            };
            "postgresql/ssl/server/key" = {
              owner = "postgres";
              group = "postgres";
            };
            "postgresql/ssl/root" = {
              owner = "postgres";
              group = "postgres";
            };
          })
        ];
      };
    };
  }
