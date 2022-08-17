{
  config,
  pkgs,
  lib,
  nur,
  nixosModules,
  ...
}: {
  imports = with nixosModules; [
    apps.editors.helix
    apps.editors.vscode
    apps.social.firefox
    apps.social.discord
    apps.utilities.gnome-terminal
    apps.utilities.gpg
    apps.utilities.qbittorrent
    ./dconf/battlestation.nix
  ];

  config = {
    home = {
      packages = with pkgs; [
        git
        vlc
        tdesktop
        dconf2nix
        rnix-lsp
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
      firefox = import ./firefox/config.nix {inherit nur;};
      gnome-terminal.settings = {
        audibleBell = false;
        colors = {
          backgroundColor = "rgb(0,0,0)";
          foregroundColor = "rgb(255,255,255)";
          palette = [
            "rgb(0,0,0)"
            "rgb(205,0,0)"
            "rgb(0,205,0)"
            "rgb(205,205,0)"
            "rgb(0,0,238)"
            "rgb(205,0,205)"
            "rgb(0,205,205)"
            "rgb(229,229,229)"
            "rgb(127,127,127)"
            "rgb(255,0,0)"
            "rgb(0,255,0)"
            "rgb(255,255,0)"
            "rgb(92,92,255)"
            "rgb(255,0,255)"
            "rgb(0,255,255)"
            "rgb(255,255,255)"
          ];
        };
        font = "JetBrains Mono 11";
        loginShell = true;
      };
      gpg.sshKeys = [
        "B0E258EAD4123779C4CFA077DBD8328FD08BADF5"
      ];
      helix.settings = builtins.readFile ./helix/config.toml;
      qbittorrent.settings = builtins.readFile ./qbittorrent/settings.conf;
      vscode = import ./vscode/config.nix {inherit pkgs;};
    };
    programs = {
      bash = {
        enable = true;
        enableVteIntegration = true;
      };
      home-manager.enable = true;
    };
  };
}
