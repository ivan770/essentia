{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wayland.windowManager.sway.config;
  modifier = cfg.modifier;
in {
  terminal = "${pkgs.foot}/bin/foot";
  menu = ''
    ${pkgs.j4-dmenu-desktop}/bin/j4-dmenu-desktop \
      --dmenu="${pkgs.bemenu}/bin/bemenu --list 10 -c -W 0.5 -f -i" \
      --term="${pkgs.foot}/bin/foot" \
      --no-generic
  '';
  bars = [];
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
  defaultWorkspace = "workspace number 1";
  up = "w";
  left = "a";
  down = "s";
  right = "d";
  keybindings = {
    "${modifier}+Return" = "exec ${cfg.menu}";
    "${modifier}+Shift+Return" = "exec ${cfg.terminal}";
    "${modifier}+Shift+q" = "kill";

    "${modifier}+${cfg.up}" = "focus up";
    "${modifier}+${cfg.left}" = "focus left";
    "${modifier}+${cfg.right}" = "focus right";
    "${modifier}+${cfg.down}" = "focus down";

    "${modifier}+Shift+${cfg.up}" = "move up";
    "${modifier}+Shift+${cfg.left}" = "move left";
    "${modifier}+Shift+${cfg.right}" = "move right";
    "${modifier}+Shift+${cfg.down}" = "move down";

    # FIXME: Remove code duplication
    "${modifier}+Up" = "focus up";
    "${modifier}+Left" = "focus left";
    "${modifier}+Right" = "focus right";
    "${modifier}+Down" = "focus down";

    "${modifier}+Shift+Up" = "move up";
    "${modifier}+Shift+Left" = "move left";
    "${modifier}+Shift+Right" = "move right";
    "${modifier}+Shift+Down" = "move down";

    "${modifier}+1" = "workspace number 1";
    "${modifier}+2" = "workspace number 2";
    "${modifier}+3" = "workspace number 3";
    "${modifier}+4" = "workspace number 4";
    "${modifier}+5" = "workspace number 5";
    "${modifier}+6" = "workspace number 6";
    "${modifier}+7" = "workspace number 7";
    "${modifier}+8" = "workspace number 8";
    "${modifier}+9" = "workspace number 9";
    "${modifier}+0" = "workspace number 10";

    "${modifier}+Shift+1" = "move container to workspace number 1";
    "${modifier}+Shift+2" = "move container to workspace number 2";
    "${modifier}+Shift+3" = "move container to workspace number 3";
    "${modifier}+Shift+4" = "move container to workspace number 4";
    "${modifier}+Shift+5" = "move container to workspace number 5";
    "${modifier}+Shift+6" = "move container to workspace number 6";
    "${modifier}+Shift+7" = "move container to workspace number 7";
    "${modifier}+Shift+8" = "move container to workspace number 8";
    "${modifier}+Shift+9" = "move container to workspace number 9";
    "${modifier}+Shift+0" = "move container to workspace number 10";

    "${modifier}+r" = "floating toggle";
    "${modifier}+f" = "fullscreen";
    "${modifier}+c" = "mode \"resize\"";

    XF86AudioMute = "exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_SINK@ toggle";
    XF86AudioLowerVolume = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_SINK@ 5%-";
    XF86AudioRaiseVolume = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_SINK@ 5%+";

    Print = "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp -d)\" - | ${pkgs.wl-clipboard}/bin/wl-copy -t image/png";
  };
  modes = {
    resize = {
      ${cfg.up} = "resize shrink height 10 px";
      ${cfg.left} = "resize shrink width 10 px";
      ${cfg.down} = "resize grow height 10 px";
      ${cfg.right} = "resize grow width 10 px";
      Escape = "mode \"default\"";
    };
  };
  bindkeysToCode = true;
  modifier = "Mod4";
}
