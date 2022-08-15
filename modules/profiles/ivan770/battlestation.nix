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
        loginShell = true;
      };
      gpg.sshKeys = [
        "B0E258EAD4123779C4CFA077DBD8328FD08BADF5"
      ];
      helix.settings = builtins.readFile ./helix/config.toml;
      qbittorrent.settings = builtins.readFile ./qbittorrent/settings.conf;
      vscode = {
        settings = builtins.readFile ./vscode/settings.json;
        keybindings = builtins.readFile ./vscode/keybindings.json;
        extensions = (import ./vscode/extensions.nix pkgs).extensions;
      };
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
