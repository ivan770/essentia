{
  config,
  lib,
  ...
}: let
  cfg = config.essentia.networking;
  networkConfig = {
    DHCP = "yes";
    DNSOverTLS = "yes";
  };
in
  with lib; {
    options.essentia.networking = {
      wired = mkEnableOption "wired networking capabilities";
      wireless = mkEnableOption "wireless networking capabilities";
    };

    config = {
      networking = {
        dhcpcd.enable = false;
        firewall.enable = false;
        networkmanager.enable = false;
        resolvconf.enable = false;
        useDHCP = false;
        useNetworkd = true;
        wireless.enable = cfg.wireless;
      };
      services.resolved.enable = true;
      systemd.network.networks = mkMerge [
        (mkIf cfg.wired {
          "20-wired" = {
            enable = true;
            name = "en*";
            inherit networkConfig;
          };
        })
        (mkIf cfg.wireless {
          "20-wireless" = {
            enable = true;
            name = "wl*";
            networkConfig =
              networkConfig
              // {
                IgnoreCarrierLoss = "3s";
              };
          };
        })
      ];
    };
  }
