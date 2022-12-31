{
  config,
  modulesPath,
  nixosModules,
  pkgs,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  essentia = {
    firmware.cpu.vendor = null;
    home-manager.profiles.ivan770 = "remote-code";
    impermanence.persistentDirectory = "/nix/persist";
    logging.flavor = "persistent";
    networking = {
      dns.preset = "server";
      wired.enable = true;
    };
    server = {
      enable = true;
      code-server.enable = true;
      containers.activatedConfigurations = {
        hedgedoc = {
          specialArgs.domain = "docs.elusive.space";
        };
        postgresql = {
          specialArgs.settings = {
            max_connections = 200;
            shared_buffers = "3GB";
            effective_cache_size = "9GB";
            maintenance_work_mem = "768MB";
            checkpoint_completion_target = 0.9;
            wal_buffers = "16MB";
            default_statistics_target = 100;
            random_page_cost = 1.1;
            effective_io_concurrency = 200;
            work_mem = "7864kB";
            min_wal_size = "1GB";
            max_wal_size = "4GB";
          };
        };
      };
      firewall.enable = true;
      nginx.activatedUpstreams = {
        "remote.elusive.space" = "code-server";
        "docs.elusive.space" = "hedgedoc-main";
      };
    };
    systemd-boot = {
      mountpoint = "/boot";
      timeout = 2;
    };
    users.activated = ["ivan770"];
  };

  boot.initrd.availableKernelModules = ["xhci_pci" "virtio_pci" "usbhid"];

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [
        "defaults"
        "size=3G"
        "mode=755"
      ];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/a367286c-5971-4719-8848-14d827784f9e";
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

  system.stateVersion = "22.11";
}
