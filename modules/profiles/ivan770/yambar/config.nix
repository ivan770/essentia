{
  config,
  battery ? false,
  lib,
  networkDevices,
  pkgs,
  wayland ? false,
  ...
} @ args: let
  spacing = 5;

  okColor = "00ff00ff";
  warnColor = "ff0000ff";

  activeColor = "7097f1ff";
  inactiveColor = "ffffff55";

  font = "Noto Sans:pixelsize=14:style=regular";
  mdIconFont = "Material Design Icons:pixelsize=14";

  call = lib.mkCall (args
    // {
      # Explicitly include "wayland" to bypass a strange Nix behaviour
      # specified in https://nixos.org/manual/nix/stable/language/constructs.html#functions
      inherit spacing okColor warnColor activeColor inactiveColor font mdIconFont wayland;
    });
in {
  bar = {
    inherit font spacing;

    height = 26;
    location = "top";

    foreground = "ffffffff";
    background = "0000004c";

    left = [
      (call ./components/workspaces.nix {})
      (call ./components/window-title.nix {})
    ];

    center = [
      (import ./components/clock.nix)
    ];

    right =
      [
        (call ./components/layout.nix {})
        (call ./components/removables.nix {})
      ]
      ++ (map (name: call ./components/network.nix {inherit name;}) networkDevices)
      ++ [
        (call ./components/sound.nix {})
        (lib.mkIf battery (call ./components/battery.nix {}))
        (call ./components/logout.nix {})
      ];
  };
}
