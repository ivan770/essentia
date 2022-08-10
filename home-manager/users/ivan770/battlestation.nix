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
        settings = builtins.readFile ./vscode/settings.json;
        keybindings = builtins.readFile ./vscode/keybindings.json;
        installExtensions = true;
        wayland = true;
      };
      qbittorrent = {
        enable = true;
        settings = builtins.readFile ./qbittorrent/settings.conf;
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
