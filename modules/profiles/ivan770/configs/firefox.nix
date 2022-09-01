{
  lib,
  nur,
  enableGnomeShell,
  ...
}:
with lib; {
  extensions = with nur.repos.rycee.firefox-addons;
    [
      bitwarden
      multi-account-containers
      steam-database
      ublock-origin
    ]
    ++ optionals enableGnomeShell [gnome-shell-integration];
  settings = {
    # Appearance stuff
    "browser.theme.content-theme" = 0;
    "browser.theme.toolbar-theme" = 0;
    "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
    "browser.toolbars.bookmarks.visibility" = "never";
    "browser.newtabpage.activity-stream.feeds.topsites" = false;
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

    # Fonts
    "font.name.monospace.x-western" = "JetBrains Mono";
    "font.name.sans-serif.x-western" = "Noto Sans";
    "font.name.serif.x-western" = "Noto Serif";

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
}
