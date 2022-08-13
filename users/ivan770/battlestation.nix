{ config, pkgs, lib, nixosModules, ... }:

{
  imports = [
    nixosModules.apps.firefox
    nixosModules.apps.gpg
    nixosModules.apps.qbittorrent
    nixosModules.apps.vscode
    ./dconf.nix
  ];

  config = {
    home = {
      packages = with pkgs; [
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
        gnome.seahorse
      ];
      stateVersion = "22.05";
    };
    essentia.programs = {
      gpg.sshKeys = [
        "B0E258EAD4123779C4CFA077DBD8328FD08BADF5"
      ];
      vscode = {
        settings = builtins.readFile ./vscode/settings.json;
        keybindings = builtins.readFile ./vscode/keybindings.json;
        installExtensions = true;
        wayland = true;
      };
      qbittorrent.settings = builtins.readFile ./qbittorrent/settings.conf;
      firefox.wayland = true;
    };
    programs = {
      bash.enable = true;
      home-manager.enable = true;
    };
  };
}
