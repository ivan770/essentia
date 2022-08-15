{ config, pkgs, ... }:

{
  config = {
    users.users.ivan770 = {
      isNormalUser = true;
      home = "/home/ivan770";
      extraGroups = [
        "networkmanager"
        "wheel"
        "tss"
      ];
      shell = pkgs.bash;
    };

    nix.settings.allowed-users = [ "ivan770" ];
  };
}
