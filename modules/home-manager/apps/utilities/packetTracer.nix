{
  lib,
  pkgs,
  ...
}:
with lib; {
  home.packages = [pkgs.ciscoPacketTracer8];

  essentia.home-impermanence = {
    directories = mkOptionDefault [
      {
        directory = ".local/share/Cisco Packet Tracer";
        mode = "0700";
      }
      "pt"
    ];

    files = mkOptionDefault [
      ".packettracer"
    ];
  };
}
