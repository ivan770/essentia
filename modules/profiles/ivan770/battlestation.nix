{
  pkgs,
  lib,
  nur,
  nixosModules,
  sops,
  ...
}: {
  imports =
    builtins.attrValues {
      inherit (nixosModules.apps.editors) helix vscode;
      inherit (nixosModules.apps.social) firefox discord;
      inherit (nixosModules.apps.utilities) direnv git gnome-terminal gpg mpv psql qbittorrent;
    }
    ++ [
      ./dconf/battlestation.nix
    ];

  home = {
    packages = builtins.attrValues {
      inherit (pkgs) lunar-client steam matlab tdesktop dconf2nix ciscoPacketTracer8;
      inherit (pkgs.gnome) gnome-system-monitor nautilus file-roller gnome-disk-utility gnome-tweaks simple-scan;
    };
    stateVersion = "22.05";
  };
  essentia.programs = {
    discord.settings = builtins.readFile ./configs/discord.json;
    firefox = import ./configs/firefox.nix {inherit lib nur;};
    git.credentials = sops.secrets."users/ivan770/git".path;
    gnome-terminal.settings = import ./configs/gnome-terminal.nix {};
    gpg.sshKeys = [
      "4F1412E8D1942B3317A706884B7A0711B34A46D6"
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
    qbittorrent.settings = ./configs/qbittorrent.conf;
    vscode = import ./vscode/config.nix {inherit pkgs;};
  };
}
