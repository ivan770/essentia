{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.essentia.programs.psql;
in
  with lib; {
    options.essentia.programs.psql = {
      rootCert = mkOption {
        type = types.path;
        description = "PostgreSQL SSL root certificate path";
      };
      cert = mkOption {
        type = types.path;
        description = "PostgreSQL client SSL certificate path";
      };
      key = mkOption {
        type = types.path;
        description = "PostgreSQL client SSL private key path";
      };
    };

    config.home.file = {
      ".postgresql/root.crt".source = cfg.rootCert;
      ".postgresql/postgresql.crt".source = cfg.cert;
      ".postgresql/postgresql.key".source = cfg.key;
    };
  }
