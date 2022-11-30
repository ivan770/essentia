{
  call,
  config,
  lib,
  pkgs,
  wayland ? false,
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

    fonts = {
      names = ["Noto Sans"];
      style = "Regular";
      size = 8.0;
    };

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
        {
          title = "Friends List";
          class = "Steam";
        }
      ];
    };

    defaultWorkspace = "workspace number 1";

    keybindings = let
      # Wrapper to correctly call commands from i3 without showing loading indicator indefinitely
      mkExec = command: "exec ${optionalString (!wayland) "--no-startup-id"} ${command}";

      workspaceKeys = zipListsWith (key: workspace: {
        "${modifier}+${toString key}" = "workspace number ${toString workspace}";
        "${modifier}+Shift+${toString key}" = "move container to workspace number ${toString workspace}";
      }) ((range 1 9) ++ [0]) (range 1 10);
    in
      {
        "${modifier}+Return" = mkExec menu;
        "${modifier}+Shift+Return" = mkExec terminal;
        "${modifier}+Shift+q" = "kill";

        "${modifier}+w" = mkExec "${pkgs.sway-overfocus}/bin/sway-overfocus split-us";
        "${modifier}+a" = mkExec "${pkgs.sway-overfocus}/bin/sway-overfocus split-ls";
        "${modifier}+s" = mkExec "${pkgs.sway-overfocus}/bin/sway-overfocus split-ds";
        "${modifier}+d" = mkExec "${pkgs.sway-overfocus}/bin/sway-overfocus split-rs";

        "${modifier}+Shift+w" = "move up";
        "${modifier}+Shift+a" = "move left";
        "${modifier}+Shift+s" = "move down";
        "${modifier}+Shift+d" = "move right";

        "${modifier}+q" = mkExec "${pkgs.sway-overfocus}/bin/sway-overfocus group-lw";
        "${modifier}+e" = mkExec "${pkgs.sway-overfocus}/bin/sway-overfocus group-rw";

        "${modifier}+r" = "floating toggle";
        "${modifier}+f" = "fullscreen";
        "${modifier}+c" = "move scratchpad";

        "${modifier}+x" = "mode \"resize\"";

        "${modifier}+Tab" = "layout toggle splitv splith tabbed";
        "${modifier}+Shift+Tab" = "split toggle";

        # FIXME: Obviously broken on Sway
        "${modifier}+grave" = let
          scratchpadCycle = pkgs.writeShellScript "scratchpad-cycle.sh" ''
            ${pkgs.i3}/bin/i3-msg -t get_tree | \
                ${pkgs.jq}/bin/jq -r '.nodes[] | .nodes[] | .nodes[]
                    | select(.name=="__i3_scratch") | .floating_nodes[]
                    | .nodes[] | (.name) + " - " + (.window | tostring)' | \
                ${runMenu config "Scratchpad:"} | \
                ${pkgs.gawk}/bin/awk '{print $NF}' | \
                ${pkgs.findutils}/bin/xargs -I{} ${pkgs.i3}/bin/i3-msg '[id="{}"] scratchpad show'
          '';
        in
          mkExec scratchpadCycle;

        # Disable window resizing with left mouse button
        "--border Button1" = "nop";

        XF86AudioPrev = mkExec "${pkgs.playerctl}/bin/playerctl previous";
        XF86AudioPlay = mkExec "${pkgs.playerctl}/bin/playerctl play-pause";
        XF86AudioNext = mkExec "${pkgs.playerctl}/bin/playerctl next";

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
            if wayland
            then grim
            else maim
          );
      }
      // recursiveMerge workspaceKeys;

    modes.resize = let
      mkResize = command: "resize ${command} 5 px or 5 ppt";
    in {
      w = mkResize "grow up";
      a = mkResize "grow left";
      s = mkResize "grow down";
      d = mkResize "grow right";

      "Shift+w" = mkResize "shrink down";
      "Shift+a" = mkResize "shrink right";
      "Shift+s" = mkResize "shrink up";
      "Shift+d" = mkResize "shrink left";

      Escape = "mode default";
    };
  }
  // optionalAttrs wayland (call ./sway.nix {})
