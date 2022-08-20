{...}: {
  mainBar = {
    layer = "top";
    position = "top";
    modules-left = [
      "sway/workspaces"
      "custom/right-arrow-dark"
    ];
    modules-center = [
      "custom/left-arrow-dark"
      "clock#1"
      "custom/left-arrow-light"
      "custom/left-arrow-dark"
      "clock#2"
      "custom/right-arrow-dark"
      "custom/right-arrow-light"
      "clock#3"
      "custom/right-arrow-dark"
    ];
    modules-right = [
      "custom/left-arrow-dark"
      "battery"
      "custom/left-arrow-light"
      "custom/left-arrow-dark"
      "tray"
    ];
    
    "custom/left-arrow-dark" = {
      format = "";
      tooltip = false;
    };
    
    "custom/left-arrow-light" = {
      format = "";
      tooltip = false;
    };
    
    "custom/right-arrow-dark" = {
      format = "";
      tooltip = false;
    };
    
    "custom/right-arrow-light" = {
      format = "";
      tooltip = false;
    };
    
    "sway/workspaces" = {
      disable-scroll = true;
      format = "{name}";
    };
    
    "clock#1" = {
      format = "{:%a}";
      tooltip = false;
    };
      
    "clock#2" = {
      format = "{:%H:%M}";
      tooltip = false;
    };
    
    "clock#3" = {
      format = "{:%d-%m}";
      tooltip = false;
    };
    
    memory = {
      interval = 5;
      format = "Mem {}%";
    };
      
    cpu = {
      interval = 5;
      format = "CPU {usage:2}%";
    };
    
    tray = {
      icon-size = 15;
    };
    
    battery = {
      states = {
        good = 95;
        warning = 30;
        critical = 20;
      };
      format = "{icon} {capacity}%";
      format-charging = " {capacity}%";
      format-plugged = " {capacity}%";
      format-alt = "{icon} {time}";
      format-icons = [
        "" "" "" "" ""
      ];
    };
    
    network = {
      format = "{ifname}";
      format-wifi = " {essid}";
      format-ethernet = " {ifname}";
      format-disconnected = "";
      tooltip-format-wifi = "{signalStrength}%";
      max-length = 20;
    };
  };
}
