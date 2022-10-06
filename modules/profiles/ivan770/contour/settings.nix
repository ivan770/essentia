{...}: {
  profiles.main = {
    cursor = {
      shape = "block";
      blinking = true;
    };
    font = {
      regular.family = "JetBrains Mono";
      size = 12;
    };
    history.limit = 10000;
    scrollbar.position = "hidden";
  };
  color_schemes.default = {
    default = {
      background = "#000000";
      foreground = "#FFFFFF";
    };

    selection = {
      background = "#FFFFFF";
      foreground = "#000000";
    };

    normal = {
      black = "#000000";
      red = "#CD0000";
      green = "#00CD00";
      yellow = "#CDCD00";
      blue = "#0000EE";
      magenta = "#CD00CD";
      cyan = "#00CDCD";
      white = "#E5E5E5";
    };

    bright = {
      black = "#7F7F7F";
      red = "#FF0000";
      green = "#00FF00";
      yellow = "#FFFF00";
      blue = "#5C5CFF";
      magenta = "#FF00FF";
      cyan = "#00FFFF";
      white = "#FFFFFF";
    };
  };
}
