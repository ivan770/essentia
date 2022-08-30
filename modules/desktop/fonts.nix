{pkgs, ...}: {
  fonts = {
    fonts = with pkgs; [
      corefonts
      noto-fonts
      noto-fonts-emoji
      liberation_ttf
      jetbrains-mono
      material-design-icons
    ];
  };
}
