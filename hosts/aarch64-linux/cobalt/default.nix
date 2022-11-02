{
  config,
  modulesPath,
  nixosModules,
  pkgs,
  ...
}: {
  imports =
    builtins.attrValues {
      inherit (nixosModules.users.ivan770) user;
      inherit (nixosModules.common) home-manager;
      inherit (nixosModules.hardware) firmware networking systemd-boot;
      inherit (nixosModules.server) code-server generic nginx postgresql;
    }
    ++ [
      (modulesPath + "/profiles/qemu-guest.nix")
    ];

  essentia = {
    firmware.cpu.vendor = null;
    home-manager.profiles.ivan770 = "remote-code";
    networking = {
      dns.preset = "server";
      wired.enable = true;
    };
    nginx.activatedUpstreams = [
      {
        name = "remote.elusive.space";
        upstream = "code-server";
      }
    ];
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
    secrets = {
      postgresql = "server";
      ssl = true;
    };
    systemd-boot = {
      mountpoint = "/boot";
      timeout = 2;
    };
  };

  boot.initrd.availableKernelModules = ["xhci_pci" "virtio_pci" "usbhid"];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/3fda6dab-8ad9-4a14-bbf6-9efa36fb775b";
      fsType = "ext4";
      options = [
        "noatime"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/F638-2D0A";
      fsType = "vfat";
    };
  };

  system.stateVersion = "22.05";
}
