{...}: {
  networking.nftables = {
    enable = true;
    # Ruleset derived from https://wiki.nftables.org/wiki-nftables/index.php/Simple_ruleset_for_a_server
    ruleset = ''
      table inet firewall {
        chain input {
          type filter hook input priority 0; policy drop;

          # Accept correct connections
          ct state { established, related } accept

          # Accept any loopback traffic
          iifname lo accept

          # Accept some ICMP traffic
          ip protocol icmp icmp type { destination-unreachable, router-advertisement, time-exceeded, parameter-problem } accept
          ip6 nexthdr icmpv6 icmpv6 type { destination-unreachable, packet-too-big, time-exceeded, parameter-problem, nd-router-advert, nd-neighbor-solicit, nd-neighbor-advert } accept

          # Allow only SSH and HTTPS connections
          tcp dport { ssh, https } accept
        }

        chain output {
          type filter hook output priority 0; policy accept;
        }

        chain forward {
          type filter hook forward priority 0; policy drop;
        }
      }
    '';
  };
}
