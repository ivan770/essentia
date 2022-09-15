{pkgs, ...}: {
  environment.defaultPackages = with pkgs;
    lib.mkForce [
      nano
    ];
  security.sudo.execWheelOnly = true;
  users.mutableUsers = false;
}
