{ lib, pkgs, config, inputs, ... }:

let
  cfg = config.essentia.desktop;
in
with lib; {
  options.essentia.desktop = {
    enable = mkEnableOption "Enable the desktop configuration";
    users = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Users and their corresponding profiles.";
    };
  };

  config = mkIf cfg.enable {
    essentia = {
      common.enable = true;
      home-manager.users = cfg.users;
      locale.enable = true;
      gnome.enable = true;
      plymouth.enable = true;
    };
  };
}
