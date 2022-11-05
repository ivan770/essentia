{
  lib,
  pkgs,
  ...
}: {
  environment.defaultPackages = lib.mkForce [pkgs.nano];
  security = {
    doas.enable = true;
    sudo.enable = false;
  };
  users.mutableUsers = false;
}
