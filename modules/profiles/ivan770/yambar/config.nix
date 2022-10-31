{
  config,
  battery ? false,
  lib,
  networkDevices,
  pkgs,
  wayland ? false,
  ...
}: let
  spacing = 5;

  okColor = "00ff00ff";
  warnColor = "ff0000ff";

  activeColor = "7097f1ff";
  inactiveColor = "ffffff55";

  font = "Noto Sans:pixelsize=14:style=regular";
  mdIconFont = "Material Design Icons:pixelsize=14";
in {
  bar = {
    inherit font spacing;

    height = 26;
    location = "top";

    foreground = "ffffffff";
    background = "0000004c";

    left = [
      (import ./components/workspaces.nix {inherit activeColor inactiveColor pkgs warnColor wayland;})
      (import ./components/window-title.nix {inherit wayland;})
    ];

    center = [
      (import ./components/clock.nix)
    ];

    right =
      [
        (import ./components/layout.nix {inherit wayland;})
        (import ./components/removables.nix {inherit okColor inactiveColor mdIconFont;})
      ]
      ++ (map (name: import ./components/network.nix {inherit lib name mdIconFont warnColor;}) networkDevices)
      ++ [
        (lib.mkIf battery (import ./components/battery.nix {inherit lib mdIconFont okColor warnColor;}))
        (import ./components/logout.nix {inherit config lib mdIconFont pkgs spacing;})
      ];
  };
}
