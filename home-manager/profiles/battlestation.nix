{ config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    vim
    firefox
    tdesktop
    dconf2nix
    discord
    qbittorrent
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
      };
    };
  };

  programs.home-manager.enable = true;

  home.stateVersion = "22.05";
}
