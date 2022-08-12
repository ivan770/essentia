{ config, lib, pkgs, ... }:

let
  cfg = config.essentia.programs.fonts;
in
with lib; {
  options.essentia.programs.fonts = {
    enable = mkEnableOption "Download common fonts and activate fontconfig";
  };

  config = mkIf cfg.enable {
    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      corefonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      jetbrains-mono
    ];
  };
}
