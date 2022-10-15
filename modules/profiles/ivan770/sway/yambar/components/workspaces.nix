{
  activeColor,
  inactiveColor,
  pkgs,
  warnColor,
  ...
}: {
  i3.content."".map = {
    tag = "state";
    values = let
      generic = {
        text = "{name}";
        margin = 5;
        on-click = "${pkgs.sway}/bin/swaymsg --quiet workspace {name}";
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
