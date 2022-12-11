{
  ciscoPacketTracer8,
  lib,
  ...
}: let
  url = "https://archive.org/download/cisco-packet-tracer-820-ubuntu-64bit-696ae-64b-25/Cisco_Packet_Tracer_820_Ubuntu_64bit_696ae64b25.deb";
  sha256 = "1b19885d59f6130ee55414fb02e211a1773460689db38bfd1ac7f0d45117ed16";
in
  ciscoPacketTracer8.override {
    requireFile = lib.partiallyRequireFile {
      "${sha256}" = "${url}";
    };
  }
