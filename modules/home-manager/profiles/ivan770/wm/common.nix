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

      workspaceKeys = recursiveMerge (
        zipListsWith (key: workspace: {
          "${modifier}+${toString key}" = "workspace number ${toString workspace}";
          "${modifier}+Shift+${toString key}" = "move container to workspace number ${toString workspace}";
        }) ((range 1 9) ++ [0]) (range 1 10)
      );

      volumeKeys = let
        devices = {
          "@DEFAULT_SINK@" = "";
          "@DEFAULT_SOURCE@" = "Shift+";
        };

        actions = device: prefix: {
          "${prefix}XF86AudioMute" = mkExec "${pkgs.wireplumber}/bin/wpctl set-mute ${device} toggle";
          "${prefix}XF86AudioLowerVolume" = mkExec "${pkgs.wireplumber}/bin/wpctl set-volume ${device} 5%-";
          "${prefix}XF86AudioRaiseVolume" = mkExec "${pkgs.wireplumber}/bin/wpctl set-volume ${device} 5%+";
        };
      in
        recursiveMerge (mapAttrsToList actions devices);
    in
      mkMerge [
        {
          "${modifier}+Return" = mkExec menu;
          "${modifier}+Shift+Return" = mkExec terminal;

          "${modifier}+Shift+q" = "kill";
          "${modifier}+Shift+e" = "mode \"resize\"";

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

          "${modifier}+Tab" = "layout toggle splitv splith tabbed";
          # FIXME: Redesign split controls to use just one combination to toggle between vertical/horizontal/no splits.
          # Currently, neither i3 nor Sway provide a command similar to "split toggle vertical horizontal none", and only Sway supports
          # "split none" at all (https://github.com/i3/i3/issues/3808).
          "${modifier}+Shift+Tab" = "split toggle";
          "${modifier}+Ctrl+Tab" = mkIf wayland "split none";

          "${modifier}+Delete" = mkExec (pkgs.writeShellScript "generate-powermenu.sh" (let
            systemctl = "${pkgs.systemd}/bin/systemctl";
            loginctl = "${pkgs.systemd}/bin/loginctl";
          in ''
            case "$(echo -e "Shutdown\nRestart\nSuspend\nLogout" | ${lib.runMenu config "Power:"})" in
                Shutdown) exec ${systemctl} poweroff;;
                Restart) exec ${systemctl} reboot;;
                Suspend) exec ${systemctl} suspend;;
                Logout) exec ${loginctl} terminate-user $USER;;
            esac
          ''));

          "${modifier}+grave" = let
            scratchpadCycle = pkgs.writeShellScript "scratchpad-cycle.sh" (let
              i3 = ''
                ${pkgs.i3}/bin/i3-msg -t get_tree | \
                  ${pkgs.jq}/bin/jq -r '.nodes[] | .nodes[] | .nodes[]
                      | select(.name=="__i3_scratch") | .floating_nodes[]
                      | .nodes[] | (.name) + " - " + (.window | tostring)' | \
                  ${runMenu config "Scratchpad:"} | \
                  ${pkgs.gawk}/bin/awk '{print $NF}' | \
                  ${pkgs.findutils}/bin/xargs -I{} ${pkgs.i3}/bin/i3-msg '[id="{}"] scratchpad show'
              '';

              sway = ''
                ${pkgs.sway}/bin/swaymsg -t get_tree | \
                  ${pkgs.jq}/bin/jq -r '.nodes[] | .nodes[]
                      | select(.name=="__i3_scratch") | .floating_nodes[]
                      | (.name) + " - " + (.id | tostring)' | \
                  ${runMenu config "Scratchpad:"} | \
                  ${pkgs.gawk}/bin/awk '{print $NF}' | \
                  ${pkgs.findutils}/bin/xargs -I{} ${pkgs.sway}/bin/swaymsg '[con_id="{}"] scratchpad show'
              '';
            in
              if wayland
              then sway
              else i3);
          in
            mkExec scratchpadCycle;

          # Disable window resizing with left mouse button
          "--border Button1" = "nop";

          XF86AudioPrev = mkExec "${pkgs.playerctl}/bin/playerctl previous";
          XF86AudioPlay = mkExec "${pkgs.playerctl}/bin/playerctl play-pause";
          XF86AudioNext = mkExec "${pkgs.playerctl}/bin/playerctl next";

          Print = let
            maim = ''
              ${pkgs.maim}/bin/maim -s -u | \
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
        workspaceKeys
        volumeKeys
      ];

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
