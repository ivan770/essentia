{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.essentia.server.postgresql;
in
  with lib; {
    options.essentia.server.postgresql = {
      apps = mkOption {
        type = types.attrsOf (types.listOf types.str);
        default = {};
        description = ''
          Available database applications.
        '';
      };
    };

    config.essentia.server.containers.configurations.postgresql = let
      package = pkgs.postgresql_15;
      dataDir = "/var/lib/postgresql";
      fullDatabaseName = name: database: "${name}_${database}";
    in {
      config = {
        exposedServices,
        settings ? {},
        ...
      }: {
        services.postgresql = {
          inherit package settings;

          enable = true;
          dataDir = "${dataDir}/${package.psqlSchema}";

          enableTCPIP = true;
          port = exposedServices.main;

          ensureUsers =
            mapAttrsToList (name: databases: {
              inherit name;

              ensurePermissions =
                listToAttrs (
                  map (database: {
                    name = "DATABASE \"${fullDatabaseName name database}\"";
                    value = "ALL PRIVILEGES";
                  })
                  databases
                )
                // {
                  # FIXME: Doesn't work correctly
                  "SCHEMA public" = "ALL";
                };
            })
            cfg.apps;

          ensureDatabases = flatten (
            mapAttrsToList (
              name: databases:
                map (
                  database: fullDatabaseName name database
                )
                databases
            )
            cfg.apps
          );

          # Trust only cross-container communication
          authentication = ''
            host all all 192.168.100.0/24 trust
          '';
        };

        system.stateVersion = "22.11";
      };

      bindSlots.data = dataDir;
      exposedServices = ["main"];
    };
  }
