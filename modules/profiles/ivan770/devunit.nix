{
  config,
  pkgs,
  lib,
  nixosConfig,
  nixosModules,
  ...
}: {
  imports = builtins.attrValues {
    inherit (nixosModules.apps.desktops) sway yambar;
    inherit (nixosModules.apps.editors) vscode;
    inherit (nixosModules.apps.social) firefox;
    inherit (nixosModules.apps.utilities) direnv fonts git gpg psql;
  };

  config = {
    home = {
      packages = builtins.attrValues {
        inherit (pkgs) tdesktop;
      };
      stateVersion = "22.05";
    };
    essentia.programs = {
      firefox =
        import ./configs/firefox.nix {inherit nixosConfig;}
        // {
          wayland = true;
        };
      git.credentials = nixosConfig.sops.secrets."users/ivan770/git".path;
      gpg.sshKeys = [
        "4F1412E8D1942B3317A706884B7A0711B34A46D6"
      ];
      psql = {
        rootCert = nixosConfig.sops.secrets."postgresql/ssl/root".path;
        cert = nixosConfig.sops.secrets."users/ivan770/postgresql/cert".path;
        key = nixosConfig.sops.secrets."users/ivan770/postgresql/key".path;
      };
      sway.settings = import ./sway/settings.nix {inherit config lib pkgs;};
      vscode = {
        settings = import ./vscode/settings.nix {inherit lib;};
        keybindings = import ./vscode/keybindings.nix;
        extensions = import ./vscode/extensions.nix {inherit pkgs;};
      };
      yambar = {
        settings = import ./sway/yambar/config.nix {
          inherit lib pkgs;
          networkDevices = ["wlo1"];
        };
        systemd.enable = true;
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
  };
}
