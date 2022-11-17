{
  call,
  lib,
  pkgs,
  nixosConfig,
  nixosModules,
  ...
}: {
  imports = builtins.attrValues {
    inherit (nixosModules.apps.desktop) feh fonts i3 menu yambar;
    inherit (nixosModules.apps.editors) vscode;
    inherit (nixosModules.apps.social) firefox discord;
    inherit (nixosModules.apps.utilities) direnv git gpg;
  };

  home.packages = builtins.attrValues {
    inherit (pkgs) lunar-client steam tdesktop ciscoPacketTracer8;
  };
  essentia.programs = {
    discord.settings = import ./configs/discord.nix;
    feh.image = "${./backgrounds/mountain.png}";
    firefox = call ./configs/firefox.nix {};
    git.credentials = nixosConfig.sops.secrets."users/ivan770/git".path;
    gpg.sshKeys = [
      "4F1412E8D1942B3317A706884B7A0711B34A46D6"
    ];
    i3 = {
      keyboard = {
        layout = "us,ru,ua";
        options = ["grp:lalt_lshift_toggle"];
      };
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
