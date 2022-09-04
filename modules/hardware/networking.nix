{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.essentia.networking;
  networkConfig = {
    # This particular attribute requires usage of "yes" instead of true.
    # According to https://www.freedesktop.org/software/systemd/man/systemd.syntax.html, both are equivalent
    DHCP = "yes";
    LLMNR = false;
  };
  dhcpV4Config = mkIf cfg.desktopDns {
    UseDNS = false;
  };
in {
  options.essentia.networking = {
    wired = mkEnableOption "wired networking capabilities";
    wireless = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = null;
      description = "Known wireless networks. If null is provided, wireless networking capabilities will be disabled";
    };
    desktopDns = mkEnableOption "desktop DNS configuration";
  };

  config = {
    networking = {
      # Disable everything we don't use
      dhcpcd.enable = false;
      firewall.enable = false;
      networkmanager.enable = false;
      resolvconf.enable = false;
      useDHCP = false;

      useNetworkd = true;
      wireless = mkIf (isList cfg.wireless) {
        enable = true;
        environmentFile = config.sops.secrets.networks.path;
        networks = builtins.listToAttrs (map (name: {
            inherit name;
            value = {
              pskRaw = "@${strings.toUpper name}@";
            };
          })
          cfg.wireless);
        dbusControlled = false;
        scanOnLowSignal = false;
      };

      nameservers = mkIf cfg.desktopDns [
        "45.90.28.0#dns1.nextdns.io"
        "45.90.30.0#dns2.nextdns.io"
      ];
    };
    services.resolved = {
      enable = true;
      llmnr = "false";
      # DNSSEC is expected to be enforced by upstream server, not a client.
      dnssec = mkIf cfg.desktopDns "false";
      extraConfig = mkIf cfg.desktopDns ''
        DNSOverTLS=true
      '';
    };
    systemd.network.networks = mkMerge [
      (mkIf cfg.wired {
        "20-wired" = {
          enable = true;
          name = "en*";
          inherit networkConfig dhcpV4Config;
        };
      })
      (mkIf (isList cfg.wireless) {
        "20-wireless" = {
          enable = true;
          name = "wl*";
          inherit networkConfig dhcpV4Config;
        };
      })
    ];
  };
}
