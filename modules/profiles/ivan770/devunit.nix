{
  config,
  pkgs,
  lib,
  nur,
  nixosModules,
  sops,
  ...
}: {
  imports = builtins.attrValues {
    inherit (nixosModules.apps.desktops) sway;
    inherit (nixosModules.apps.editors) helix vscode;
    inherit (nixosModules.apps.social) firefox;
    inherit (nixosModules.apps.utilities) direnv fonts git gpg;
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
        import ./configs/firefox.nix {inherit lib nur;}
        // {
          wayland = true;
        };
      git.credentials = sops.secrets."users/ivan770/git".path;
      gpg.sshKeys = [
        "4F1412E8D1942B3317A706884B7A0711B34A46D6"
      ];
      helix.settings = builtins.readFile ./configs/helix.toml;
      sway = {
        swaySettings = import ./sway/settings.nix {inherit config lib pkgs;};
        waybarSettings = import ./sway/waybar/bars.nix {inherit pkgs;};
        waybarStyle = builtins.readFile ./sway/waybar/style.css;
      };
      vscode = import ./vscode/config.nix {inherit pkgs;};
    };
    programs = {
      alacritty = {
        enable = true;
        settings = import ./configs/alacritty.nix {};
      };
      lf =
        import ./configs/lf.nix {}
        // {
          enable = true;
        };
    };
  };
}
