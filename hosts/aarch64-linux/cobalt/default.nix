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
    networking = {
      dns.preset = "server";
      wired.enable = true;
    };
    secrets.ssl = true;
    server = {
      enable = true;
      code-server.enable = true;
      containers.activatedConfigurations.hedgedoc = {
        bindMounts.data = "/var/lib/hedgedoc-data";
        network = {
          localAddress = "192.168.100.1";
          hostAddress = "192.168.101.1";
        };
        specialArgs.domain = "docs.elusive.space";
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

  system.stateVersion = "22.11";
}
