{
  call,
  lib,
  nixosConfig,
  nixosModules,
  pkgs,
  ...
}: {
  imports = builtins.attrValues {
    inherit (nixosModules.home-manager.apps.editors) code-server;
    inherit (nixosModules.home-manager.apps.utilities) direnv git gpg;
  };

  essentia.programs = {
    code-server = {
      settings = call ./vscode/settings.nix {};
      keybindings = import ./vscode/keybindings.nix;
      extensions = call ./vscode/extensions.nix {};
    };
    git.credentials = nixosConfig.sops.secrets."users/ivan770/git".path;
    gpg.sshKeys = [
      "4F1412E8D1942B3317A706884B7A0711B34A46D6"
    ];
  };
  programs.helix = {
    enable = true;
    settings = import ./configs/helix.nix;
  };
}