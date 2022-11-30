{wayland, ...}:
if wayland
then {
  sway-xkb = {
    identifiers = ["1:1:AT_Translated_Set_2_keyboard"];
    content.string.text = "{layout}";
  };
}
else {
  xkb.content.string.text = "{name}";
}
