{
  lib,
  pkgs,
  ...
}: {
  environment.defaultPackages = lib.mkForce [pkgs.nano];
  security = {
    doas = {
      enable = true;
      # Force to override the default "wheel" group configuration.
      extraRules = lib.mkForce [
        {
          groups = ["wheel"];
          keepEnv = true;
          # Fix missing git binary error when rebuilding system configuration
          setEnv = ["PATH"];
        }
      ];
    };
    sudo.enable = false;
  };
  users.mutableUsers = false;
}
