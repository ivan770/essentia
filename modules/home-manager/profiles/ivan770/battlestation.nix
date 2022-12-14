{
  call,
  lib,
  pkgs,
  nixosConfig,
  nixosModules,
  ...
}: {
  imports =
    builtins.attrValues {
      inherit (nixosModules.home-manager.apps.desktop) feh fonts i3 menu yambar;
      inherit (nixosModules.home-manager.apps.editors) helix vscode;
      inherit (nixosModules.home-manager.apps.games) lunar-client steam;
      inherit (nixosModules.home-manager.apps.social) firefox discord tdesktop;
      inherit (nixosModules.home-manager.apps.utilities) deluge direnv git gpg packetTracer;
    }
    ++ [
      ./impermanence.nix
    ];

  essentia.programs = {
    discord.settings = import ./configs/discord.nix;
    feh.image = "${./backgrounds/mountain.png}";
    firefox = call ./configs/firefox.nix {};
    git.credentials = nixosConfig.sops.secrets."users/ivan770/git".path;
    gpg.sshKeys = [
      "4F1412E8D1942B3317A706884B7A0711B34A46D6"
    ];
    helix.settings = import ./configs/helix.nix;
    i3 = {
      keyboard = {
        layout = "us,ru,ua";
        options = ["grp:caps_toggle"];
      };
      mouse.speed = -0.139013;
      config = call ./wm/common.nix {};
      extraConfig = call ./wm/extraConfig.nix {};
    };
    vscode = {
      settings = call ./vscode/settings.nix {};
      keybindings = import ./vscode/keybindings.nix;
      extensions = call ./vscode/extensions.nix {};
    };
    yambar = {
      settings = call ./yambar/config.nix {
        networkDevices = ["enp9s0"];
      };
      systemd.target = "i3";
    };
  };
  programs.alacritty = {
    enable = true;
    settings = import ./configs/alacritty.nix;
  };
}
