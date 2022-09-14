{
  config,
  pkgs,
  lib,
  nur,
  nixosModules,
  sops,
  ...
}: {
  imports = with nixosModules; [
    apps.desktops.sway
    apps.editors.helix
    apps.editors.vscode
    apps.social.firefox
    apps.utilities.direnv
    apps.utilities.git
    apps.utilities.gpg
  ];

  config = {
    home = {
      packages = with pkgs; [
        tdesktop
      ];
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
        "B0E258EAD4123779C4CFA077DBD8328FD08BADF5"
      ];
      helix.settings = builtins.readFile ./configs/helix.toml;
      sway = {
        swaySettings = import ./sway/sway.nix {inherit config lib pkgs;};
        waybarSettings = import ./sway/waybar/bars.nix {inherit pkgs;};
        waybarStyle = builtins.readFile ./sway/waybar/style.css;
      };
      vscode =
        import ./vscode/config.nix {inherit pkgs;}
        // {
          wayland = true;
        };
    };
    programs.foot = {
      enable = true;
      settings = import ./configs/foot.nix {};
    };
  };
}
