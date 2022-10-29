{config, ...}: {
  input."type:keyboard" = {
    xkb_layout = "us,ru,ua";
    xkb_options = "grp:lalt_lshift_toggle";
  };

  input."type:touchpad" = {
    tap = "enabled";
    natural_scroll = "enabled";
    scroll_method = "two_finger";
  };

  output."*".bg = "${../backgrounds/mountain.png} fill";

  seat = {
    "*" = {
      xcursor_theme = "${config.gtk.cursorTheme.name} ${builtins.toString config.gtk.cursorTheme.size}";
    };
  };

  bindkeysToCode = true;
}
