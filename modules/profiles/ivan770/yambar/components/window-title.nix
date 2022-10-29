{wayland, ...}:
if wayland
then {
  foreign-toplevel.content.map = {
    tag = "activated";
    values = {
      false.empty = {};
      true.string = {
        text = "{title}";
        max = 70;
      };
    };
  };
}
else {
  xwindow.content.string = {
    text = "{title}";
    max = 70;
  };
}
