{
  okColor,
  lib,
  mdIconFont,
  warnColor,
  ...
}: {
  battery = {
    name = "BAT0";
    poll-interval = 30;
    content.map = {
      tag = "state";
      values = let
        connectedAc = text: [
          {
            string = {
              inherit text;
              foreground = okColor;
              font = mdIconFont;
            };
          }
          {string.text = "{capacity}%";}
        ];

        batteryStates = [
          {
            text = "󰁺";
            warn = true;
          }
          {
            text = "󰁻";
            warn = true;
          }
          {
            text = "󰁼";
            warn = false;
          }
          {
            text = "󰁽";
            warn = false;
          }
          {
            text = "󰁾";
            warn = false;
          }
          {
            text = "󰁿";
            warn = false;
          }
          {
            text = "󰂀";
            warn = false;
          }
          {
            text = "󰂁";
            warn = false;
          }
          {
            text = "󰂂";
            warn = false;
          }
          {
            text = "󰁹";
            warn = false;
          }
        ];

        disconnectedAc =
          map (state: {
            string = {
              inherit (state) text;
              foreground = lib.mkIf state.warn warnColor;
              font = mdIconFont;
            };
          })
          batteryStates;
      in {
        full = connectedAc "󱟢";
        charging = connectedAc "󰂄";
        discharging = [
          {
            ramp = {
              tag = "capacity";
              items = disconnectedAc;
            };
          }
          {
            string.text = "{capacity}%";
          }
        ];
      };
    };
  };
}
