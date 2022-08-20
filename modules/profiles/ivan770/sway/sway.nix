{pkgs,...}: {
  terminal = "alacritty";
  bars = [
    {
      command = "${pkgs.waybar}/bin/waybar";
      position = "top";
    }
  ];
  input."*" = {
    xkb_layout = "us,ru,ua";
    xkb_options = "grp:lalt_lshift_toggle";
  };
  input."type:touchpad" = {
    tap = "enabled";
    natural_scroll = "enabled";
    scroll_method = "two_finger";
  };
  bindkeysToCode = true;
  modifier = "Mod4";
}
