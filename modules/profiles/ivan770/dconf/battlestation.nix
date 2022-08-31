# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{lib, ...}:
with lib.hm.gvariant; {
  dconf.settings = {
    "apps/seahorse/listing" = {
      keyrings-selected = ["gnupg://"];
    };

    "apps/seahorse/windows/key-manager" = {
      height = 476;
      width = 1056;
    };

    "org/gnome/control-center" = {
      last-panel = "mouse";
      window-state = mkTuple [980 820];
    };

    "org/gnome/desktop/app-folders" = {
      folder-children = ["0c4f3931-521e-4951-8d18-beef06aed854" "52ab9df1-abdc-4d60-8ea4-838768e5002d" "f61696a4-9056-4e56-9dbd-6d732283a8cb"];
    };

    "org/gnome/desktop/app-folders/folders/0c4f3931-521e-4951-8d18-beef06aed854" = {
      apps = ["org.gnome.Tour.desktop" "nixos-manual.desktop" "org.gnome.Extensions.desktop" "cups.desktop" "xterm.desktop"];
      name = "Junk";
      translate = false;
    };

    "org/gnome/desktop/app-folders/folders/52ab9df1-abdc-4d60-8ea4-838768e5002d" = {
      apps = ["org.gnome.Settings.desktop" "gnome-system-monitor.desktop" "org.gnome.tweaks.desktop" "org.gnome.DiskUtility.desktop"];
      name = "Utilities";
      translate = false;
    };

    "org/gnome/desktop/app-folders/folders/f61696a4-9056-4e56-9dbd-6d732283a8cb" = {
      apps = ["steam.desktop" "LEGO Star Wars The Skywalker Saga.desktop" "Garry's Mod.desktop" "com.lunarclient.LunarClient.desktop"];
      name = "Games";
    };

    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      # Original artwork: https://www.deviantart.com/rmradev/art/Mountains-877397825
      picture-uri = "${../backgrounds/mountain.png}";
      picture-uri-dark = "${../backgrounds/mountain.png}";
      primary-color = "#000000000000";
      secondary-color = "#000000000000";
    };

    "org/gnome/desktop/input-sources" = {
      per-window = false;
      show-all-sources = false;
      sources = [(mkTuple ["xkb" "us"]) (mkTuple ["xkb" "ru"]) (mkTuple ["xkb" "ua"])];
      xkb-options = ["terminate:ctrl_alt_bksp" "grp:alt_shift_toggle"];
    };

    "org/gnome/desktop/interface" = {
      clock-show-date = false;
      color-scheme = "prefer-dark";
      cursor-size = 32;
      enable-hot-corners = false;
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      gtk-im-module = "gtk-im-context-simple";
      gtk-theme = "Adwaita-dark";
      toolkit-accessibility = false;
    };

    "org/gnome/desktop/notifications" = {
      application-children = ["org-gnome-console" "telegramdesktop" "firefox" "org-qbittorrent-qbittorrent" "gnome-system-monitor" "org-gnome-nautilus" "org-gnome-fileroller" "steam" "org-gnome-tweaks"];
    };

    "org/gnome/desktop/notifications/application/firefox" = {
      application-id = "firefox.desktop";
    };

    "org/gnome/desktop/notifications/application/gnome-system-monitor" = {
      application-id = "gnome-system-monitor.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-console" = {
      application-id = "org.gnome.Console.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-fileroller" = {
      application-id = "org.gnome.FileRoller.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-nautilus" = {
      application-id = "org.gnome.Nautilus.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-tweaks" = {
      application-id = "org.gnome.tweaks.desktop";
    };

    "org/gnome/desktop/notifications/application/org-qbittorrent-qbittorrent" = {
      application-id = "org.qbittorrent.qBittorrent.desktop";
    };

    "org/gnome/desktop/notifications/application/steam" = {
      application-id = "steam.desktop";
    };

    "org/gnome/desktop/notifications/application/telegramdesktop" = {
      application-id = "telegramdesktop.desktop";
    };

    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
      speed = -0.139013;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/privacy" = {
      disable-camera = true;
      disable-microphone = false;
      old-files-age = mkUint32 30;
      recent-files-max-age = -1;
      remember-recent-files = false;
      remove-old-temp-files = true;
    };

    "org/gnome/desktop/screensaver" = {
      lock-enabled = false;
    };

    "org/gnome/desktop/search-providers" = {
      sort-order = ["org.gnome.Contacts.desktop" "org.gnome.Documents.desktop" "org.gnome.Nautilus.desktop"];
    };

    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 0;
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };

    "org/gnome/epiphany" = {
      ask-for-default = false;
    };

    "org/gnome/evolution-data-server" = {
      migrated = true;
      network-monitor-gio-name = "";
    };

    "org/gnome/file-roller/dialogs/extract" = {
      recreate-folders = true;
      skip-newer = false;
    };

    "org/gnome/file-roller/listing" = {
      list-mode = "as-folder";
      name-column-width = 250;
      show-path = false;
      sort-method = "name";
      sort-type = "ascending";
    };

    "org/gnome/file-roller/ui" = {
      sidebar-width = 200;
      window-height = 480;
      window-width = 600;
    };

    "org/gnome/gnome-system-monitor" = {
      current-tab = "processes";
      maximized = false;
      network-total-in-bits = false;
      show-dependencies = false;
      show-whose-processes = "user";
      window-state = mkTuple [700 500];
    };

    "org/gnome/gnome-system-monitor/disktreenew" = {
      col-6-visible = true;
      col-6-width = 0;
    };

    "org/gnome/gnome-system-monitor/proctree" = {
      columns-order = [0 1 2 3 4 6 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26];
      sort-col = 8;
      sort-order = 0;
    };

    "org/gnome/mutter" = {
      attach-modal-dialogs = true;
      dynamic-workspaces = true;
      edge-tiling = true;
      focus-change-on-pointer-rest = true;
      workspaces-only-on-primary = true;
    };

    "org/gnome/nautilus/compression" = {
      default-compression-format = "zip";
    };

    "org/gnome/nautilus/icon-view" = {
      default-zoom-level = "small";
    };

    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "icon-view";
      search-filter-time-type = "last_modified";
      search-view = "list-view";
    };

    "org/gnome/nautilus/window-state" = {
      initial-size = mkTuple [890 550];
      maximized = false;
    };

    "org/gnome/nm-applet/eap/4aa265f4-aea5-4eda-a5a7-a8b7577a947b" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "nothing";
      sleep-inactive-ac-type = "nothing";
    };

    "org/gnome/shell" = {
      app-picker-layout = "[{'f61696a4-9056-4e56-9dbd-6d732283a8cb': <{'position': <0>}>, '52ab9df1-abdc-4d60-8ea4-838768e5002d': <{'position': <1>}>, 'org.gnome.Terminal.desktop': <{'position': <2>}>, 'discord.desktop': <{'position': <3>}>, 'org.qbittorrent.qBittorrent.desktop': <{'position': <4>}>, 'telegramdesktop.desktop': <{'position': <5>}>, 'code.desktop': <{'position': <6>}>, 'org.gnome.FileRoller.desktop': <{'position': <7>}>, '0c4f3931-521e-4951-8d18-beef06aed854': <{'position': <8>}>, 'org.gnome.seahorse.Application.desktop': <{'position': <9>}>}]";
      enabled-extensions = ["appindicatorsupport@rgcjonas.gmail.com" "dash-to-dock@micxgx.gmail.com"];
      favorite-apps = ["firefox.desktop" "org.gnome.Nautilus.desktop"];
      welcome-dialog-last-shown-version = "42.3.1";
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      apply-custom-theme = true;
      background-opacity = 0.8;
      dash-max-icon-size = 48;
      dock-position = "BOTTOM";
      height-fraction = 0.9;
      hot-keys = false;
      intellihide = false;
      intellihide-mode = "ALL_WINDOWS";
      isolate-locations = false;
      multi-monitor = true;
      show-mounts = false;
      show-trash = false;
    };

    "org/gnome/shell/world-clocks" = {
      locations = "@av []";
    };

    "org/gnome/tweaks" = {
      show-extensions-notice = false;
    };

    "org/gtk/gtk4/settings/file-chooser" = {
      date-format = "regular";
      location-mode = "path-bar";
      show-hidden = false;
      show-size-column = true;
      show-type-column = true;
      sidebar-width = 169;
      sort-column = "name";
      sort-directories-first = false;
      sort-order = "ascending";
      type-format = "category";
      window-size = mkTuple [888 327];
    };

    "org/gtk/settings/color-chooser" = {
      selected-color = mkTuple [true 1.0];
    };

    "org/gtk/settings/file-chooser" = {
      date-format = "regular";
      location-mode = "path-bar";
      show-hidden = false;
      show-size-column = true;
      show-type-column = true;
      sidebar-width = 170;
      sort-column = "name";
      sort-directories-first = false;
      sort-order = "ascending";
      type-format = "category";
      window-position = mkTuple [26 23];
      window-size = mkTuple [1203 902];
    };

    "system/proxy" = {
      mode = "none";
    };
  };
}
