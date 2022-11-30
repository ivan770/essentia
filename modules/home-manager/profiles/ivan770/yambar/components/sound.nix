{
  mdIconFont,
  pkgs,
  spacing,
  warnColor,
  ...
}: {
  pulse.content.list = {
    inherit spacing;

    items = let
      mkUnmutedIcon = text: {
        string = {
          inherit text;
          font = mdIconFont;
        };
      };

      mkMutedIcon = text: {
        string = {
          inherit text;
          font = mdIconFont;
          foreground = warnColor;
        };
      };

      sink.list = {
        on-click = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_SINK@ toggle";
        items = [
          {
            map.conditions = {
              sink_muted = mkMutedIcon "󰝟";
              "~sink_muted".ramp = {
                tag = "sink_percent";
                items = map mkUnmutedIcon [
                  "󰕿"
                  "󰖀"
                  "󰕾"
                ];
              };
            };
          }
          {
            string.text = "{sink_percent}%";
          }
        ];
      };

      source.list = {
        on-click = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_SOURCE@ toggle";
        items = [
          {
            map.conditions = {
              source_muted = mkMutedIcon "󰍭";
              "~source_muted" = mkUnmutedIcon "󰍬";
            };
          }
          {
            string.text = "{source_percent}%";
          }
        ];
      };
    in [
      sink
      source
    ];
  };
}
