{
  activeColor,
  inactiveColor,
  pkgs,
  warnColor,
  wayland,
  ...
}: {
  i3.content."".map = {
    tag = "state";
    values = let
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
      unfocused.string = generic;
      focused.string = generic // {deco.stack = [{background.color = activeColor;}];};
      invisible.string = generic // {foreground = inactiveColor;};
      urgent.string =
        generic
        // {
          deco.stack = [{background.color = warnColor;}];
        };
    };
  };
}
