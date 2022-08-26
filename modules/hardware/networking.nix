{config, ...}: let
  networkConfig = {
    DHCP = "yes";
    DNSOverTLS = "yes";
  };
in {
  config = {
    networking = {
      dhcpcd.enable = false;
      firewall.enable = false;
      networkmanager.enable = false;
      resolvconf.enable = false;
      useDHCP = false;
      useNetworkd = true;
    };
    services.resolved.enable = true;
    systemd.network.networks = {
      "20-wired" = {
        enable = true;
        name = "en*";
        inherit networkConfig;
      };
    };
  };
}
