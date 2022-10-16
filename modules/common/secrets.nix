{
  lib,
  config,
  ...
}: let
  cfg = config.essentia.secrets;
in
  with lib; {
    options.essentia.secrets = {
      postgresql = mkOption {
        type = types.nullOr (types.enum ["client" "server"]);
        default = null;
        description = ''
          PostgreSQL secrets type to activate.
        '';
      };
      ssl = mkEnableOption "ssl secrets needed for nginx";
    };

    config.sops = {
      defaultSopsFile = ../../secrets.yaml;
      secrets = mkMerge [
        {
          "users/ivan770/password".neededForUsers = true;
          "users/ivan770/git" = {
            owner = config.users.users.ivan770.name;
            group = config.users.users.ivan770.group;
          };
          networks = {};
          trustedNetworks = {};
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
        (mkIf (cfg.postgresql == "client") {
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
        (mkIf (cfg.postgresql == "server") {
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
  }
