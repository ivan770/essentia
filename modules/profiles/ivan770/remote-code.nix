{
  nixosModules,
  pkgs,
  sops,
  ...
}: {
  imports = builtins.attrValues {
    inherit (nixosModules.apps.editors) code-server helix;
    inherit (nixosModules.apps.utilities) direnv git gpg;
  };

  home.stateVersion = "22.05";
  essentia.programs = {
    code-server = import ./vscode/config.nix {inherit pkgs;};
    git.credentials = sops.secrets."users/ivan770/git".path;
    gpg.sshKeys = [
      "B0E258EAD4123779C4CFA077DBD8328FD08BADF5"
    ];
    helix.settings = builtins.readFile ./configs/helix.toml;
  };
}
