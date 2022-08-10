{ config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    git
    vim
    tdesktop
    dconf2nix
    discord
    rnix-lsp
    gnome-console
    gnome.gnome-system-monitor
    gnome.nautilus
    gnome.file-roller
    gnome.gnome-disk-utility
    gnome.gnome-tweaks
  ];

  essentia = {
    programs = {
      vscode = {
        enable = true;
        installExtensions = true;
        installConfig = true;
        wayland = true;
      };
      qbittorrent = {
        enable = true;
        installConfig = true;
      };
      firefox = {
        enable = true;
        wayland = true;
      };
    };
  };

  programs.home-manager.enable = true;

  home.stateVersion = "22.05";
}
