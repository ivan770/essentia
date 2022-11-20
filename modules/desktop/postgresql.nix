{
  lib,
  pkgs,
  ...
}: {
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;
    enableTCPIP = true;
    # Trust loopback TCP/IP connections
    # Derived from https://www.postgresql.org/docs/current/auth-pg-hba-conf.html
    authentication = ''
      host all all 127.0.0.1/32 trust
    '';
  };

  # Explicitly disable auto-start since not every desktop session requires PostgreSQL.
  systemd.services.postgresql.wantedBy = lib.mkForce [];
}
