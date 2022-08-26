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
    apps.utilities.mpv
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
        gnome.simple-scan
      ];
      stateVersion = "22.05";
    };
    essentia.programs = {
      discord.settings = builtins.readFile ./configs/discord.json;
      firefox = import ./configs/firefox.nix {
        inherit lib nur;
        enableGnomeShell = true;
      };
      gnome-terminal.settings = import ./configs/gnome-terminal.nix {};
      gpg.sshKeys = [
        "B0E258EAD4123779C4CFA077DBD8328FD08BADF5"
      ];
      helix.settings = builtins.readFile ./configs/helix.toml;
      mpv = {
        userProfile = import ./configs/mpv.nix;
        activatedProfiles = [
          "audio-normalization"
          "large-cache-buffer"
          "nvidia"
        ];
      };
      qbittorrent.settings = builtins.readFile ./configs/qbittorrent.conf;
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
