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
    secrets.ssl = true;
    server = {
      enable = true;
      code-server.enable = true;
      containers.activatedConfigurations.hedgedoc = {
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
