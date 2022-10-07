{pkgs, ...}: {
  # Required for default system-wide fonts configuration.
  # See fonts.fontconfig.defaultFonts.* for more information.
  fonts.fonts = builtins.attrValues {
    inherit (pkgs) dejavu_fonts noto-fonts-emoji;
  };
}
