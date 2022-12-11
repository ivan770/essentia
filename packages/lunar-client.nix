{
  appimageTools,
  fetchurl,
  lib,
  makeDesktopItem,
  ...
}: let
  name = "lunar-client";
  version = "2.14.0";

  desktopItem = makeDesktopItem {
    name = "lunar-client";
    exec = "lunar-client";
    icon = "lunarclient";
    comment = "Minecraft 1.7, 1.8, 1.12, 1.15, 1.16, 1.17, and 1.18 Client";
    desktopName = "Lunar Client";
    genericName = "Minecraft Client";
    categories = ["Game"];
  };

  appimageContents = appimageTools.extract {
    inherit name src;
  };

  src = fetchurl {
    url = "https://launcherupdates.lunarclientcdn.com/Lunar%20Client-${version}.AppImage";
    name = "lunar-client.AppImage";
    sha256 = "sha256-bKpNiqQQXk+dGCo2TRVkQ4gaimoFrylyIVRPODhC3Io=";
  };
in
  appimageTools.wrapType1 {
    inherit name src;

    extraInstallCommands = ''
      mkdir -p $out/share/applications
      cp ${desktopItem}/share/applications/* $out/share/applications
      cp -r ${appimageContents}/usr/share/icons/ $out/share/
    '';

    extraPkgs = pkgs: [pkgs.libpulseaudio];

    meta = with lib; {
      description = "Minecraft 1.7, 1.8, 1.12, 1.15, 1.16, 1.17, and 1.18 Client";
      homepage = "https://www.lunarclient.com/";
      license = with licenses; [unfree];
      platforms = ["x86_64-linux"];
    };
  }
