{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.essentia.networking.dns;
in {
  options.essentia.networking.dns = {
    preset = mkOption {
      type = types.enum ["desktop" "server"];
      description = ''
        Preferred DNS configuration preset
      '';
    };
  };

  config = {
    networking.nameservers = mkIf (cfg.preset == "desktop") [
      "45.90.28.0#dns1.nextdns.io"
      "45.90.30.0#dns2.nextdns.io"
    ];
    services.resolved = {
      enable = true;
      llmnr = "false";
      # DNSSEC is expected to be enforced by an upstream server, not a client.
      dnssec = mkIf (cfg.preset == "desktop") "false";
      extraConfig = ''
        ${optionalString (cfg.preset == "desktop") "DNSOverTLS=true"}
        MulticastDNS=false
      '';
    };
  };
}
