{
  config,
  pkgs,
  lib,
  nur,
  nixosModules,
  ...
}: {
  imports = with nixosModules; [
    apps.editors.helix
    apps.editors.vscode
    apps.social.firefox
    apps.utilities.gpg
    desktop.hm-sway
  ];

  config = {
    home = {
      packages = with pkgs; [
        git
        tdesktop
        rnix-lsp
      ];
      stateVersion = "22.05";
    };
    essentia = {
      programs = {
        firefox =
          import ./configs/firefox.nix {
            inherit lib nur;
            enableGnomeShell = false;
          }
          // {
            wayland = true;
          };
        gpg.sshKeys = [
          "B0E258EAD4123779C4CFA077DBD8328FD08BADF5"
        ];
        helix.settings = builtins.readFile ./configs/helix.toml;
        vscode =
          import ./vscode/config.nix {inherit pkgs;}
          // {
            wayland = true;
          };
      };
      sway = {
        swaySettings = import ./sway/sway.nix {inherit config lib pkgs;};
        waybarSettings = import ./sway/waybar/bars.nix {};
        waybarStyle = builtins.readFile ./sway/waybar/style.css;
      };
    };
    programs = {
      bash = {
        enable = true;
        enableVteIntegration = true;
      };
      home-manager.enable = true;
      foot = {
        enable = true;
        settings = import ./configs/foot.nix {};
      };
    };
  };
}
