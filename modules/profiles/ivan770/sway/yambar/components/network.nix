{
  name,
  mdIconFont,
  warnColor,
  ...
}: {
  network = {
    inherit name;

    content.map = {
      tag = "carrier";
      values = {
        false.string = {
          text = "󰤭";
          font = mdIconFont;
          foreground = warnColor;
        };
        true.string = {
          text = "󰤨";
          font = mdIconFont;
        };
        # FIXME: Display signal strength as soon as yambar 1.9 gets released.
        # true.map = {
        #   tag = "state";
        #   default = disconnected;
        #   values.up.map = {
        #     tag = "signal";
        #     default.string = {
        #       text = "󰤠";
        #       font = mdIconFont;
        #       foreground = "ff0000ff";
        #     };
        #     values = let
        #       mkSignalIcon = text: {
        #         string = {
        #           inherit text;
        #           font = mdIconFont;
        #           foreground = "ffffffff";
        #         };
        #       };
        #     in {
        #       ">-50" = mkSignalIcon "󰤨";
        #       ">-60" = mkSignalIcon "󰤥";
        #       ">-70" = mkSignalIcon "󰤢";
        #     };
        #   };
        # };
      };
    };
  };
}
