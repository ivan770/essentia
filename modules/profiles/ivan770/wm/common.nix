{
  config,
  lib,
  pkgs,
  sway ? false,
  ...
}:
with lib; let
  modifier = "Mod4";
  terminal = "${config.programs.alacritty.package}/bin/alacritty";
  menu = ''
    ${pkgs.j4-dmenu-desktop}/bin/j4-dmenu-desktop \
      --dmenu="${runMenu config "Run:"}" \
      --term="${terminal}" \
      --no-generic
  '';
in
  {
    inherit modifier terminal menu;

    bars = [];

    window = {
      border = 1;
      titlebar = false;
      hideEdgeBorders = "smart";
      commands = [
        {
          command = "border pixel 1";
          criteria.class = "^.*";
        }
      ];
    };

    floating = {
      border = 1;
      titlebar = false;
      criteria = [
        {title = "Picture-in-Picture";}
      ];
    };

    defaultWorkspace = "workspace number 1";

    keybindings = let
      # Wrapper to correctly call commands from i3 without showing loading indicator indefinitely
      mkExec = command: "exec ${optionalString (!sway) "--no-startup-id"} ${command}";
    in {
      "${modifier}+Return" = mkExec menu;
      "${modifier}+Shift+Return" = mkExec terminal;
      "${modifier}+Shift+q" = "kill";

      "${modifier}+w" = "focus up";
      "${modifier}+a" = "focus left";
      "${modifier}+s" = "focus down";
      "${modifier}+d" = "focus right";

      "${modifier}+Shift+w" = "move up";
      "${modifier}+Shift+a" = "move left";
      "${modifier}+Shift+s" = "move down";
      "${modifier}+Shift+d" = "move right";

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
      "${modifier}+c" = "move scratchpad";

      # FIXME: Obviously broken on Sway
      "${modifier}+Tab" = let
        scratchpadCycle = pkgs.writeShellScript "scratchpad-cycle.sh" ''
          ${pkgs.i3}/bin/i3-msg -t get_tree | \
              ${pkgs.jq}/bin/jq -r '.nodes[] | .nodes[] | .nodes[] | select(.name=="__i3_scratch") | .floating_nodes[] | .nodes[] | .name' | \
              ${runMenu config "Scratchpad:"} | \
              ${pkgs.findutils}/bin/xargs -I{} ${pkgs.i3}/bin/i3-msg '[title="{}"] scratchpad show'
        '';
      in
        mkExec scratchpadCycle;

      XF86AudioMute = mkExec "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_SINK@ toggle";
      XF86AudioLowerVolume = mkExec "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_SINK@ 5%-";
      XF86AudioRaiseVolume = mkExec "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_SINK@ 5%+";

      Print = let
        maim = ''
          ${pkgs.maim}/bin/maim -s | \
            ${pkgs.xclip}/bin/xclip -selection clipboard -t image/png
        '';

        grim = ''
          ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -d)" - | \
            ${pkgs.wl-clipboard}/bin/wl-copy -t image/png
        '';
      in
        mkExec (
          if sway
          then grim
          else maim
        );
    };
  }
  // optionalAttrs sway (import ./sway.nix {inherit config;})
