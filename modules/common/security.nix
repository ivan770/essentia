{pkgs, ...}: {
  environment.defaultPackages = with pkgs;
    lib.mkForce [
      nano
    ];
  security.sudo = {
    execWheelOnly = true;
    extraConfig = ''
      Defaults lecture=never
    '';
  };
  users.mutableUsers = false;
}
