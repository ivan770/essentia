{pkgs, ...}: {
  mainBar = {
    layer = "top";
    position = "top";
    modules-left = [
      "clock"
      "battery"
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
      format-ethernet = "󰈀 {ipaddr}";
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
      on-click = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_SINK@ toggle";
      on-scroll-up = "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_SINK@ 1%+";
      on-scroll-down = "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_SINK@ 1%-";
    };

    "pulseaudio#source" = {
      format = "{format_source}";
      format-source = "󰍬 {volume}%";
      format-source-muted = "󰍭";
      on-click = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_SOURCE@ toggle";
      on-scroll-up = "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_SOURCE@ 1%+";
      on-scroll-down = "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_SOURCE@ 1%-";
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
      on-click = "${pkgs.wlogout}/bin/wlogout";
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
