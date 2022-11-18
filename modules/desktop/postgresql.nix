{
  lib,
  pkgs,
  ...
}: {
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;
    enableTCPIP = true;
  };

  # Explicitly disable auto-start since not every desktop session requires PostgreSQL.
  systemd.services.postgresql.wantedBy = lib.mkForce [];
}
