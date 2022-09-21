{...}: {
  networking.nftables = {
    enable = true;
    # Ruleset derived from https://wiki.nftables.org/wiki-nftables/index.php/Simple_ruleset_for_a_server
    ruleset = ''
      table inet firewall {
        chain input {
          type filter hook input priority 0; policy drop;

          # Accept already established connections, reject invalid ones
          ct state { established, related } accept
          ct state invalid drop

          # Accept any loopback traffic
          iifname lo accept

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
