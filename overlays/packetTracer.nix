inputs: let
  inherit inputs;
in
  self: super:
    with super; {
      ciscoPacketTracer8 = let
        version = "8.2.0";

        ptFiles = stdenv.mkDerivation {
          name = "PacketTracer8Drv";
          inherit version;

          dontUnpack = true;
          src = fetchurl {
            url = "https://archive.org/download/cisco-packet-tracer-820-ubuntu-64bit-696ae-64b-25/Cisco_Packet_Tracer_820_Ubuntu_64bit_696ae64b25.deb";
            sha256 = "GxmIXVn2Ew7lVBT7AuIRoXc0YGids4v9Gsfw1FEX7RY=";
          };

          nativeBuildInputs =
            [
              alsa-lib
              autoPatchelfHook
              dbus
              dpkg
              expat
              fontconfig
              glib
              libdrm
              libglvnd
              libpulseaudio
              libudev0-shim
              libxkbcommon
              libxml2
              libxslt
              makeWrapper
              nspr
              nss
            ]
            ++ (with xorg; [
              libICE
              libSM
              libX11
              libxcb
              libXcomposite
              libXcursor
              libXdamage
              libXext
              libXfixes
              libXi
              libXrandr
              libXrender
              libXScrnSaver
              libXtst
              xcbutilimage
              xcbutilkeysyms
              xcbutilrenderutil
              xcbutilwm
            ]);

          installPhase = ''
            dpkg-deb -x $src $out
            chmod 755 "$out"
            makeWrapper "$out/opt/pt/bin/PacketTracer" "$out/bin/packettracer" \
              --prefix LD_LIBRARY_PATH : "$out/opt/pt/bin"

            # Keep source archive cached, to avoid re-downloading
            ln -s $src $out/usr/share/
          '';
        };

        desktopItem = makeDesktopItem {
          name = "cisco-pt8.desktop";
          desktopName = "Cisco Packet Tracer 8";
          icon = "${ptFiles}/opt/pt/art/app.png";
          exec = "packettracer8 %f";
          mimeTypes = ["application/x-pkt" "application/x-pka" "application/x-pkz"];
        };

        fhs = buildFHSUserEnvBubblewrap {
          name = "packettracer8";
          runScript = "${ptFiles}/bin/packettracer";
          targetPkgs = pkgs: [pkgs.libudev0-shim];

          extraInstallCommands = ''
            mkdir -p "$out/share/applications"
            cp "${desktopItem}"/share/applications/* "$out/share/applications/"
          '';
        };
      in
        stdenv.mkDerivation {
          pname = "ciscoPacketTracer8";
          inherit version;

          dontUnpack = true;

          installPhase = ''
            mkdir $out
            ${super.xorg.lndir}/bin/lndir -silent ${fhs} $out
          '';

          desktopItems = [desktopItem];
          nativeBuildInputs = [copyDesktopItems];

          meta = with lib; {
            description = "Network simulation tool from Cisco";
            homepage = "https://www.netacad.com/courses/packet-tracer";
            license = licenses.unfree;
            platforms = ["x86_64-linux"];
          };
        };
    }
