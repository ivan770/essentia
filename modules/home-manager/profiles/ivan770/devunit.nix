{
  config,
  pkgs,
  lib,
  nixosConfig,
  nixosModules,
  ...
} @ args: let
  call = lib.mkCall (args
    // {
      wayland = true;
    });
in {
  imports =
    builtins.attrValues {
      inherit (nixosModules.home-manager.apps.desktop) fonts menu sway yambar;
      inherit (nixosModules.home-manager.apps.editors) vscode;
      inherit (nixosModules.home-manager.apps.social) firefox tdesktop;
      inherit (nixosModules.home-manager.apps.utilities) direnv git gpg packetTracer;
    }
    ++ [
      ./impermanence.nix
    ];

  essentia.programs = {
    firefox = call ./configs/firefox.nix {};
    git.credentials = nixosConfig.sops.secrets."users/ivan770/git".path;
    gpg.sshKeys = [
      "4F1412E8D1942B3317A706884B7A0711B34A46D6"
    ];
    sway = {
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
        battery = true;
        networkDevices = ["wlan0"];
      };
      systemd.target = "sway";
    };
  };
  programs = {
    alacritty = {
      enable = true;
      settings = import ./configs/alacritty.nix;
    };
    helix = {
      enable = true;
      settings = import ./configs/helix.nix;
    };
  };
}
