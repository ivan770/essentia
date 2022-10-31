{wayland, ...}:
if wayland
then {
  foreign-toplevel.content.map = {
    conditions = {
      activated.string = {
        text = "{title}";
        max = 70;
      };
      "~activated".empty = {};
    };
  };
}
else {
  xwindow.content.string = {
    text = "{title}";
    max = 70;
  };
}
