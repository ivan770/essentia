{
  networkDevices,
  pkgs,
  ...
}: let
  mdIconFont = "Material Design Icons:pixelsize=14";
in {
  bar = {
    height = 26;
    location = "top";
    spacing = 5;

    font = "JetBrains Mono:pixelsize=14";

    foreground = "ffffffff";
    background = "111111cc";

    left = [
      {
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
            focused.string = generic // {deco.stack = [{background.color = "ffa0a04c";}];};
            invisible.string = generic // {foreground = "ffffff55";};
            urgent.string =
              generic
              // {
                foreground = "000000ff";
                deco.stack = [{background.color = "bc2b3fff";}];
              };
          };
        };
      }

      {
        foreign-toplevel.content.map = {
          tag = "activated";
          values = {
            false.empty = {};
            true.string.text = "{title}";
          };
        };
      }
    ];

    right =
      [
        {
          sway-xkb = {
            identifiers = ["1:1:AT_Translated_Set_2_keyboard"];
            content.string.text = "{layout}";
          };
        }
      ]
      ++ (map (name: {
          network = {
            inherit name;

            content.map = {
              tag = "carrier";
              values = {
                false.string = {
                  text = "󰤭";
                  font = mdIconFont;
                  foreground = "ff0000ff";
                };
                true.string = {
                  text = "󰤨";
                  font = mdIconFont;
                  foreground = "ffffffff";
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
        })
        networkDevices)
      ++ [
        {
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
                      foreground = "00ff00ff";
                      font = mdIconFont;
                    };
                  }
                  {string.text = "{capacity}%";}
                ];

                batteryStates = [
                  {
                    text = "󰁺";
                    foreground = "ff0000ff";
                  }
                  {
                    text = "󰁻";
                    foreground = "ffa600ff";
                  }
                  {
                    text = "󰁼";
                    foreground = "ffffffff";
                  }
                  {
                    text = "󰁽";
                    foreground = "ffffffff";
                  }
                  {
                    text = "󰁾";
                    foreground = "ffffffff";
                  }
                  {
                    text = "󰁿";
                    foreground = "ffffffff";
                  }
                  {
                    text = "󰂀";
                    foreground = "ffffffff";
                  }
                  {
                    text = "󰂁";
                    foreground = "ffffffff";
                  }
                  {
                    text = "󰂂";
                    foreground = "ffffffff";
                  }
                  {
                    text = "󰁹";
                    foreground = "ffffffff";
                  }
                ];

                disconnectedAc =
                  map (state: {
                    string = {
                      inherit (state) text foreground;
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

        {
          clock = {
            date-format = "%e %B %Y";
            time-format = "%H:%M";
            content.string.text = "{date}, {time}";
          };
        }

        {
          label.content.string = {
            text = "󰍃";
            font = mdIconFont;
            right-margin = 5;
            on-click = let
              wlogoutStyle = pkgs.writeText "wlogout-style.css" (
                builtins.replaceStrings ["$icons"] ["${pkgs.wlogout}/share/wlogout/icons"] (builtins.readFile ../wlogout/style.css)
              );
            in
              pkgs.writeShellScript "launch-wlogout.sh" ''
                ${pkgs.wlogout}/bin/wlogout \
                  --css ${wlogoutStyle} \
                  --layout ${../wlogout/layout} \
                  --buttons-per-row 2 \
                  --margin-top 300 \
                  --margin-bottom 300 \
                  --margin-left 600 \
                  --margin-right 600 \
                  --protocol layer-shell
              '';
          };
        }
      ];
  };
}
