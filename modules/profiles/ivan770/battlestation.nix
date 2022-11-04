{
  config,
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
    inherit (nixosModules.apps.utilities) direnv git gpg psql;
  };

  home.packages = builtins.attrValues {
    inherit (pkgs) lunar-client steam tdesktop ciscoPacketTracer8;
  };
  essentia.programs = {
    discord.settings = import ./configs/discord.nix;
    feh.image = "${./backgrounds/mountain.png}";
    firefox = import ./configs/firefox.nix {inherit nixosConfig;};
    git.credentials = nixosConfig.sops.secrets."users/ivan770/git".path;
    gpg.sshKeys = [
      "4F1412E8D1942B3317A706884B7A0711B34A46D6"
    ];
    i3 = {
      keyboard = {
        layout = "us,ru,ua";
        options = ["grp:lalt_lshift_toggle"];
      };
      config = import ./wm/common.nix {inherit config lib pkgs;};
      extraConfig = import ./wm/extraConfig.nix {};
    };
    psql = {
      rootCert = nixosConfig.sops.secrets."postgresql/ssl/root".path;
      cert = nixosConfig.sops.secrets."users/ivan770/postgresql/cert".path;
      key = nixosConfig.sops.secrets."users/ivan770/postgresql/key".path;
    };
    vscode = {
      settings = import ./vscode/settings.nix {inherit lib;};
      keybindings = import ./vscode/keybindings.nix;
      extensions = import ./vscode/extensions.nix {inherit pkgs;};
    };
    yambar = {
      settings = import ./yambar/config.nix {
        inherit config lib pkgs;
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
    lf =
      import ./configs/lf.nix
      // {
        enable = true;
      };
  };
}
