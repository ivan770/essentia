{pkgs, ...}: let
  wlogoutStyle = pkgs.writeText "wlogout-style.css" (
    builtins.replaceStrings ["$icons"] ["${pkgs.wlogout}/share/wlogout/icons"] (builtins.readFile ../wlogout/style.css)
  );
in {
  mainBar = {
    layer = "top";
    position = "top";
    modules-left = [
      "clock"
      "battery"
      "bluetooth"
      "pulseaudio#sink"
      "pulseaudio#source"
      "custom/cap-left"
    ];
    modules-center = [
      "sway/workspaces"
    ];
    modules-right = [
      "custom/cap-right"
      "sway/language"
      "network"
      "tray"
      "custom/offswitch"
    ];

    battery = {
      states = {
        full = 90;
        warning = 30;
        critical = 15;
      };
      tooltip = false;
      full-at = 95;
      format-plugged = "{icon} {capacity}%";
      format-charging = "{icon} {capacity}%";
      format = "{icon} {capacity}%";
      format-icons = [
        "󰁺"
        "󰁻"
        "󰁼"
        "󰁽"
        "󰁾"
        "󰁿"
        "󰂀"
        "󰂁"
        "󰂂"
        "󰁹"
      ];
    };

    clock = {
      format = "{:%a %b %d %H:%M}";
      tooltip = false;
    };

    network = {
      interval = 10;
      format-wifi = "{icon} {essid}";
      format-ethernet = "󰈀 Connected";
      format-disconnected = "󰅤 Disconnected";
      format-icons = [
        "󰤟"
        "󰤢"
        "󰤥"
        "󰤨"
      ];
      tooltip = false;
      max-length = 20;
    };

    bluetooth = {
      tooltip = false;
      max-length = 5;
      format = "󰂯 {status}";
      format-disabled = "󰂲";
      format-off = "󰂲";
      format-on = "󰂯";
      format-connected = "󰂱";
      format-connected-battery = "󰂱 {device_battery_percentage}%";
    };

    "pulseaudio#sink" = {
      tooltip = false;
      min-length = 5;
      format = "{icon} {volume}%";
      format-bluetooth = "{icon}󰂰 {volume}%";
      format-muted = "󰖁";
      format-icons = {
        headphone = "󰋋";
        speaker = "󰓃";
        hdmi = "󰡁";
        headset = "󰋎";
        default = "󰕾";
      };
      on-click = "${pkgs.pamixer}/bin/pamixer -t";
      on-scroll-up = "${pkgs.pamixer}/bin/pamixer -i 1 --set-limit 100";
      on-scroll-down = "${pkgs.pamixer}/bin/pamixer -d 1 --set-limit 100";
    };

    "pulseaudio#source" = {
      tooltip = false;
      format = "{format_source}";
      format-source = "󰍬 {volume}%";
      format-source-muted = "󰍭";
      on-click = "${pkgs.pamixer}/bin/pamixer --default-source -t";
      on-scroll-up = "${pkgs.pamixer}/bin/pamixer --default-source -i 1 --set-limit 100";
      on-scroll-down = "${pkgs.pamixer}/bin/pamixer --default-source -d 1 --set-limit 100";
    };

    "sway/workspaces" = {
      tooltip = false;
      disable-scroll = true;
    };

    "sway/language" = {
      tooltip = false;
    };

    "custom/offswitch" = {
      tooltip = false;
      format = "󰍃";
      interval = "once";
      on-click = ''
        ${pkgs.wlogout}/bin/wlogout \
          --css ${wlogoutStyle} \
          --layout ${../wlogout/layout} \
          --buttons-per-row 2 \
          --margin-top 300 \
          --margin-bottom 300 \
          --margin-left 600 \
          --margin-right 600 \
          --protocol layer-shell
      '';
    };

    "custom/cap-left" = {
      tooltip = false;
      format = "";
    };

    "custom/cap-right" = {
      tooltip = false;
      format = "";
    };
  };
}
