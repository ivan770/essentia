{ lib, config, pkgs, ... }:

let
  cfg = config.essentia.user.ivan770;
in
with lib; {
  options.essentia.user.ivan770 = {
    enable = mkEnableOption "Activate user ivan770";
  };

  config = mkIf cfg.enable {
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
