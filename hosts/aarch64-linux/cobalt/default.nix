{
  nixosModules,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    nixosModules.users.ivan770
    nixosModules.hardware.firmware
    nixosModules.hardware.networking
    nixosModules.hardware.systemd-boot
    nixosModules.server.generic
    nixosModules.server.postgresql
  ];

  config = {
    essentia = {
      networking.wired = true;
      postgresql.serverConfig = {
        # PGTune suggestions
        max_connections = 25;
        shared_buffers = "6GB";
        effective_cache_size = "18GB";
        maintenance_work_mem = "1536MB";
        checkpoint_completion_target = 0.9;
        wal_buffers = "16MB";
        default_statistics_target = 100;
        random_page_cost = 1.1;
        effective_io_concurrency = 200;
        work_mem = "125829kB";
        min_wal_size = "1GB";
        max_wal_size = "4GB";
        max_worker_processes = 4;
        max_parallel_workers_per_gather = 2;
        max_parallel_workers = 4;
        max_parallel_maintenance_workers = 2;
      };
      secrets.postgresqlSecrets = true;
      systemd-boot.mountpoint = "/boot";
    };

    boot.kernelPackages = pkgs.linuxPackages_hardened;

    system.stateVersion = "22.05";
  };
}
