{
  pkgs,
  lib,
  nixosConfig,
  nixosModules,
  ...
}: {
  imports =
    builtins.attrValues {
      inherit (nixosModules.apps.editors) vscode;
      inherit (nixosModules.apps.social) firefox discord;
      inherit (nixosModules.apps.utilities) direnv fonts git gpg mpv psql qbittorrent;
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
    discord.settings = import ./configs/discord.nix;
    firefox = import ./configs/firefox.nix {inherit nixosConfig;};
    git.credentials = nixosConfig.sops.secrets."users/ivan770/git".path;
    gpg.sshKeys = [
      "4F1412E8D1942B3317A706884B7A0711B34A46D6"
    ];
    mpv = {
      userProfile = import ./configs/mpv.nix;
      activatedProfiles = [
        "audio-normalization"
        "large-cache-buffer"
        "nvidia"
      ];
    };
    psql = {
      rootCert = nixosConfig.sops.secrets."postgresql/ssl/root".path;
      cert = nixosConfig.sops.secrets."users/ivan770/postgresql/cert".path;
      key = nixosConfig.sops.secrets."users/ivan770/postgresql/key".path;
    };
    qbittorrent.settings = ./configs/qbittorrent.conf;
    vscode = import ./vscode/config.nix {inherit lib pkgs;};
  };
  programs = {
    alacritty = {
      enable = true;
      settings = import ./configs/alacritty.nix {};
    };
    helix = {
      enable = true;
      settings = import ./configs/helix.nix;
    };
  };
}
