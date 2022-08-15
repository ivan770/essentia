{ config, pkgs, lib, nur, nixosModules, ... }:

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
      firefox = {
        extensions = with nur.repos.rycee.firefox-addons; [
          bitwarden
          gnome-shell-integration
          multi-account-containers
          steam-database
          ublock-origin
        ];
        settings = {
          # Appearance stuff
          "browser.theme.content-theme" = 0;
          "browser.theme.toolbar-theme" = 0;
          "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
          "browser.toolbars.bookmarks.visibility" = "never";
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

          # Privacy stuff
          "dom.security.https_only_mode" = true;
          "dom.security.https_only_mode_ever_enabled" = true;
          "privacy.donottrackheader.enabled" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;

          # Disable builtin password manager
          "signon.rememberSignons" = false;
          "signon.management.page.breach-alerts.enabled" = false;

          # Disable all notification prompts
          "permissions.default.desktop-notification" = 2;

          # Skip welcome screen
          "trailhead.firstrun.didSeeAboutWelcome" = true;
        };
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
      bash.enable = true;
      home-manager.enable = true;
    };
  };
}
