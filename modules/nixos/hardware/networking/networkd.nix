{
  config,
  lib,
  nixosModules,
  ...
}:
with lib; let
  cfg = config.essentia.networking;
in {
  options.essentia.networking = {
    wired.enable = mkEnableOption "wired networking capabilities";
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
    };
    systemd.network.networks = let
      networkConfig = {
        # This particular attribute requires usage of "yes" instead of true.
        # According to https://www.freedesktop.org/software/systemd/man/systemd.syntax.html, both are equivalent
        DHCP = "yes";

        # networkd's DNS section is used only for link-specific configuration of resolved
        LLMNR = false;
        MulticastDNS = false;
      };
      dhcpV4Config = mkIf (cfg.dns.preset == "desktop") {
        UseDNS = false;
      };
    in
      mkMerge [
        (mkIf cfg.wired.enable {
          "20-wired" = {
            inherit networkConfig dhcpV4Config;

            enable = true;
            name = "en*";
          };
        })
        (mkIf cfg.wireless.enable {
          "20-wireless" = {
            inherit dhcpV4Config;

            enable = true;
            name = "wl*";

            networkConfig =
              networkConfig
              // {
                IgnoreCarrierLoss = "5s";
              };
          };
        })
      ];
  };
}
