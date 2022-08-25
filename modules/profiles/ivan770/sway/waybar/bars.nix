{pkgs, ...}: {
  mainBar = {
    layer = "top";
    position = "top";
    modules-left = [
      "clock"
      "battery"
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
        ""
        ""
        ""
        ""
        ""
        ""
        ""
        ""
        ""
        ""
      ];
    };

    clock = {
      format = "{:%a %b %d %H:%M}";
      tooltip = false;
    };

    network = {
      interval = 10;
      format-wifi = "直 {essid}";
      format-ethernet = " {ipaddr}";
      format-disconnected = " Disconnected";
      tooltip = false;
      max-length = 20;
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
      format = "";
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
