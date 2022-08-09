{ lib, config, ... }:

let
  cfg = config.essentia.common;
in
with lib; {
  options.essentia.common = {
    enable = mkEnableOption "Activate common Nix configuration options";
  };

  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;
  };
}
