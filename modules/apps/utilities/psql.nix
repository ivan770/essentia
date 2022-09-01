{
  config,
  lib,
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

    config.systemd.user.tmpfiles.rules = [
      "L ${config.home.homeDirectory}/.postgresql/root.crt - - - - ${cfg.rootCert}"
      "L ${config.home.homeDirectory}/.postgresql/postgresql.crt - - - - ${cfg.cert}"
      "L ${config.home.homeDirectory}/.postgresql/postgresql.key - - - - ${cfg.key}"
    ];
  }
