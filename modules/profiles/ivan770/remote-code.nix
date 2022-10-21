{
  nixosConfig,
  nixosModules,
  pkgs,
  ...
}: {
  imports = builtins.attrValues {
    inherit (nixosModules.apps.editors) code-server;
    inherit (nixosModules.apps.utilities) direnv git gpg;
  };

  home.stateVersion = "22.05";
  essentia.programs = {
    code-server = import ./vscode/config.nix {inherit pkgs;};
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
