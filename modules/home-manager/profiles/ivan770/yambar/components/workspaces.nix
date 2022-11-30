{
  activeColor,
  inactiveColor,
  pkgs,
  warnColor,
  wayland,
  ...
}: {
  i3.content."".map.conditions = let
    generic = {
      text = "{name}";
      margin = 5;
      on-click = let
        socket =
          if wayland
          then "${pkgs.sway}/bin/swaymsg"
          else "${pkgs.i3}/bin/i3-msg";
      in "${socket} --quiet workspace {name}";
    };
  in {
    "state == unfocused".string = generic;
    "state == focused".string = generic // {deco.stack = [{background.color = activeColor;}];};
    "state == invisible".string = generic // {foreground = inactiveColor;};
    "state == urgent".string =
      generic
      // {
        deco.stack = [{background.color = warnColor;}];
      };
  };
}
