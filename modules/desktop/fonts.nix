{
  config,
  pkgs,
  ...
}: {
  config.fonts = {
    fonts = with pkgs; [
      corefonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      jetbrains-mono
    ];
  };
}
