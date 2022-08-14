{ config, pkgs, lib, nixosModules, ... }:

{
  imports = [
    nixosModules.apps.discord
    nixosModules.apps.firefox
    nixosModules.apps.gpg
    nixosModules.apps.helix
    nixosModules.apps.qbittorrent
    nixosModules.apps.vscode
    ./dconf/battlestation.nix
  ];

  config = {
    home = {
      packages = with pkgs; [
        git
        tdesktop
        dconf2nix
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
      discord.settings = builtins.readFile ./discord/settings.json;
      gpg.sshKeys = [
        "B0E258EAD4123779C4CFA077DBD8328FD08BADF5"
      ];
      helix.settings = builtins.readFile ./helix/config.toml;
      qbittorrent.settings = builtins.readFile ./qbittorrent/settings.conf;
      vscode = {
        settings = builtins.readFile ./vscode/settings.json;
        keybindings = builtins.readFile ./vscode/keybindings.json;
        installExtensions = true;
      };
    };
    programs = {
      bash.enable = true;
      home-manager.enable = true;
    };
  };
}
