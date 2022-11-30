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
    firmware.cpu.vendor = null;
    home-manager.profiles.ivan770 = "remote-code";
    networking = {
      dns.preset = "server";
      wired.enable = true;
    };
    nginx.activatedUpstreams = {
      "remote.elusive.space" = "code-server";
      "docs.elusive.space" = "hedgedoc-main";
    };
    secrets.ssl = true;
    server-kernel.enable = true;
    systemd-boot = {
      mountpoint = "/boot";
      timeout = 2;
    };
    systemd-initrd.enable = true;
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

  system.stateVersion = "22.05";
}
