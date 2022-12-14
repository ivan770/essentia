{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.essentia.server.firewall;

  mkCfIPList = version: sha256: (
    replaceStrings ["\n"] [", "] (
      readFile (builtins.fetchurl {
        inherit sha256;
        url = "https://www.cloudflare.com/ips-" + version;
      })
    )
  );

  cfV4List = mkCfIPList "v4" "0ywy9sg7spafi3gm9q5wb59lbiq0swvf0q3iazl0maq1pj1nsb7h";
  cfV6List = mkCfIPList "v6" "1ad09hijignj6zlqvdjxv7rjj8567z357zfavv201b9vx3ikk7cy";
in {
  options.essentia.server.firewall = {
    enable = mkEnableOption "server-tailored firewall support";

    protectedPorts = mkOption {
      type = types.listOf types.int;
      default = [];
      description = ''
        Ports that can accept incoming traffic, but only from trusted networks.
      '';
    };

    forwardedInterfaces = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        Interfaces that have their traffic forwarded through the main outgoing interface.
      '';
    };
  };

  config.networking.nftables = mkIf cfg.enable {
    enable = true;
    # Ruleset derived from https://wiki.nftables.org/wiki-nftables/index.php/Simple_ruleset_for_a_server
    ruleset = let
      mkForwardedInterfacesRule = criteria: rule:
        optionalString (cfg.forwardedInterfaces != []) "${criteria} { ${concatStringsSep " " (map (interface: "\"${interface}\"") cfg.forwardedInterfaces)} } ${rule}";

      mkForwardedInterfacesInputRule = rule: mkForwardedInterfacesRule "iifname" rule;
    in ''
      include "${config.sops.secrets.trustedNetworks.path}"

      define CF_IPV4 = { ${cfV4List} }
      define CF_IPV6 = { ${cfV6List} }

      table inet firewall {
        chain input {
          type filter hook input priority 0; policy drop;

          # Accept correct connections and immediately drop invalid ones
          ct state vmap { established : accept, related : accept, invalid : drop }

          # Accept any loopback traffic
          iifname lo accept

          # Accept some ICMP traffic
          ip protocol icmp icmp type { destination-unreachable, router-advertisement, time-exceeded, parameter-problem } accept
          ip6 nexthdr icmpv6 icmpv6 type { destination-unreachable, packet-too-big, time-exceeded, parameter-problem, nd-router-advert, nd-neighbor-solicit, nd-neighbor-advert } accept

          # Allow SSH and HTTPS connections
          tcp dport https ip saddr $CF_IPV4 accept
          tcp dport https ip6 saddr $CF_IPV6 accept
          tcp dport { ${concatStringsSep ", " (map toString cfg.protectedPorts)} } ip saddr $TRUSTED_NETWORKS accept
        }

        chain output {
          type filter hook output priority 0; policy accept;
        }

        chain forward {
          type filter hook forward priority 0; policy drop;

          # Accept correct connections and immediately drop invalid ones
          ct state vmap { established : accept, related : accept, invalid : drop }

          # Forward cross-container packets
          iifname "ve-*" oifname "ve-*" accept

          # Accept packets that interact with the forwarded interfaces
          ${mkForwardedInterfacesInputRule "accept"}
        }

        chain postrouting {
          type nat hook postrouting priority 100; policy accept;

          # Enable forwarded interfaces IP masquerade
          ${mkForwardedInterfacesInputRule "masquerade random"}
        }
      }
    '';
  };
}
