{
  lib,
  nur,
  ...
}:
with lib; {
  extensions = builtins.attrValues {
    inherit (nur.repos.rycee.firefox-addons) bitwarden multi-account-containers ublock-origin;
  };
  settings = {
    # Appearance stuff
    "browser.theme.content-theme" = 0;
    "browser.theme.toolbar-theme" = 0;
    "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
    "browser.toolbars.bookmarks.visibility" = "never";
    "browser.newtabpage.activity-stream.feeds.topsites" = false;
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
    "browser.newtabpage.enhanced" = false;
    "browser.newtabpage.introShown" = true;
    "browser.startup.homepage_override.mstone" = "ignore";
    "browser.urlbar.trimURLs" = false;

    # Disable microphone badge during calls
    "privacy.webrtc.legacyGlobalIndicator" = false;
    "privacy.webrtc.hideGlobalIndicator" = true;

    # Fonts
    "font.name.monospace.x-western" = "JetBrains Mono";
    "font.name.sans-serif.x-western" = "Noto Sans";
    "font.name.serif.x-western" = "Noto Serif";

    # Privacy stuff
    "browser.sessionstore.privacy_level" = 2;
    "dom.security.https_only_mode" = true;
    "dom.security.https_only_mode_ever_enabled" = true;
    "privacy.donottrackheader.enabled" = true;
    "privacy.donottrackheader.value" = 1;
    "privacy.query_stripping" = true;
    "privacy.trackingprotection.enabled" = true;
    "privacy.trackingprotection.cryptomining.enabled" = true;
    "privacy.trackingprotection.fingerprinting.enabled" = true;
    "privacy.trackingprotection.pbmode.enabled" = true;
    "privacy.trackingprotection.socialtracking.enabled" = true;

    # Disable noisy default browser check
    "browser.shell.checkDefaultBrowser" = false;

    # Disable builtin password manager
    "signon.autofillForms" = false;
    "signon.rememberSignons" = false;
    "signon.management.page.breach-alerts.enabled" = false;

    # Disable all notification prompts
    "permissions.default.desktop-notification" = 2;

    # Disable about:config warning
    "browser.aboutConfig.showWarning" = false;

    # Skip welcome screen
    "trailhead.firstrun.didSeeAboutWelcome" = true;
  };
}
