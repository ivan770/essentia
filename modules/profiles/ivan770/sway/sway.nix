{
  lib,
  pkgs,
  ...
}: {
  terminal = "foot";
  menu = "bemenu-run --list 10 -c -W 0.5 -f";
  bars = [];
  input."*" = {
    xkb_layout = "us,ru,ua";
    xkb_options = "grp:lalt_lshift_toggle";
  };
  input."type:touchpad" = {
    tap = "enabled";
    natural_scroll = "enabled";
    scroll_method = "two_finger";
  };
  keybindings = lib.mkOptionDefault {
    Print = "exec grim -g \"$(slurp -d)\" - | wl-copy -t image/png";
  };
  bindkeysToCode = true;
  modifier = "Mod4";
}
