{
  pkgs,
  lib,
  nur,
  nixosModules,
  sops,
  ...
}: {
  imports = with nixosModules; [
    apps.editors.helix
    apps.editors.vscode
    apps.social.firefox
    apps.social.discord
    apps.utilities.direnv
    apps.utilities.git
    apps.utilities.gnome-terminal
    apps.utilities.gpg
    apps.utilities.mpv
    apps.utilities.psql
    apps.utilities.qbittorrent
    ./dconf/battlestation.nix
  ];

  home = {
    packages = with pkgs; [
      matlab
      tdesktop
      dconf2nix
      rnix-lsp
      ciscoPacketTracer8
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
    git.credentials = sops.secrets."users/ivan770/git".path;
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
    psql = {
      rootCert = sops.secrets."postgresql/ssl/root".path;
      cert = sops.secrets."users/ivan770/postgresql/cert".path;
      key = sops.secrets."users/ivan770/postgresql/key".path;
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
}
