{
  config,
  lib,
  pkgs,
  ...
}: {
  terminal = "${pkgs.foot}/bin/foot";
  menu = "${pkgs.bemenu}/bin/bemenu-run --list 10 -c -W 0.5 -f";
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
  seat = {
    "*" = {
      xcursor_theme = "${config.gtk.cursorTheme.name} ${builtins.toString config.gtk.cursorTheme.size}";
    };
  };
  keybindings = lib.mkOptionDefault {
    Print = "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp -d)\" - | ${pkgs.wl-clipboard}/bin/wl-copy -t image/png";
  };
  bindkeysToCode = true;
  modifier = "Mod4";
}
