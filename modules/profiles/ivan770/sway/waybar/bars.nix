{...}: {
  mainBar = {
    layer = "top";
    modules-left = [
      "network"
    ];
    modules-right = [
      "battery"
      "clock"
    ];

    network = {
      tooltip = false;
      format-wifi = "SSID: {essid}";
      format-ethernet = "";
    };

    battery = {
      states = {
        good = 95;
        warning = 30;
        critical = 20;
      };
      format = "{icon} {capacity}%";
      format-charging = "Charging";
      format-plugged = "Plugged";
      format-alt = "{time} {icon}";
      format-icons = [
        "1"
        "2"
        "3"
        "4"
        "5"
      ];
    };

    clock = {
      format = "%I:%M %p";
    };
  };
}
