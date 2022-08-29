{
  config,
  lib,
  ...
}: let
  cfg = config.essentia.networking;
  networkConfig = {
    DHCP = "yes";
    DNSOverTLS =
      if cfg.dnsOverTls
      then "yes"
      else "no";
  };
in
  with lib; {
    options.essentia.networking = {
      wired = mkEnableOption "wired networking capabilities";
      wireless = mkOption {
        type = types.nullOr (types.listOf types.str);
        default = null;
        description = "Known wireless networks. If null is provided, wireless networking capabilities will be disabled";
      };
      dnsOverTls = mkEnableOption "global DNS-over-TLS";
    };

    config = {
      networking = {
        dhcpcd.enable = false;
        firewall.enable = false;
        networkmanager.enable = false;
        resolvconf.enable = false;
        useDHCP = false;
        useNetworkd = true;
        wireless = mkIf (isList cfg.wireless) {
          enable = true;
          environmentFile = config.sops.secrets.networks.path;
          networks = builtins.listToAttrs (map (ssid: {
              name = ssid;
              value = {
                pskRaw = "@${strings.toUpper ssid}@";
              };
            })
            cfg.wireless);
          dbusControlled = false;
          scanOnLowSignal = false;
        };
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
        (mkIf (isList cfg.wireless) {
          "20-wireless" = {
            enable = true;
            name = "wl*";
            inherit networkConfig;
          };
        })
      ];
    };
  }
