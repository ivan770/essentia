{ config, pkgs, lib, home-manager, ... }:

let
  cfg = config.essentia.home-manager;
in
with lib; {
  options.essentia.home-manager = {
    enable = mkEnableOption "Enable home-manager";

    profile = mkOption {
      type = types.str;
      default = "battlestation";
      description = "Configuration profile to be used";
      example = "devunit";
    };

    username = mkOption {
      type = types.str;
      default = "ivan770";
      description = "User that will receive the configuration profile";
      example = "myusername";
    };
  };

  imports = [
    home-manager.nixosModules.home-manager
  ];

  config = mkIf cfg.enable {
    home-manager.useUserPackages = true;

    home-manager.users."${cfg.username}" = {
      imports = [
        ./profiles/${cfg.profile}.nix
      ] ++ map (x: import (./modules/${x})) (builtins.attrNames (builtins.readDir ./modules));
    };
  };
}
