{
  okColor,
  inactiveColor,
  mdIconFont,
  ...
}: {
  removables.content.map.conditions = let
    text = "󱊞";
    font = mdIconFont;
  in {
    mounted.string = {
      inherit text font;
      foreground = okColor;
    };
    "~mounted".string = {
      inherit text font;
      foreground = inactiveColor;
    };
  };
}
