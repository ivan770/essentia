{ lib, config, pkgs, ... }:

let
  enabled = config.essentia.user.ivan770;
in
with lib; {
  options.essentia.user.ivan770 = mkEnableOption "Activate user ivan770";

  config = mkIf enabled {
    users.users.ivan770 = {
      isNormalUser = true;
      home = "/home/ivan770";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      shell = pkgs.bash;
    };

    nix.settings.allowed-users = [ "ivan770" ];
  };
}
