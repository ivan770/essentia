{pkgs, ...}: {
  fonts.fontconfig.enable = true;

  home.packages = builtins.attrValues {
    inherit (pkgs) corefonts liberation_ttf jetbrains-mono material-design-icons noto-fonts;
  };
}
