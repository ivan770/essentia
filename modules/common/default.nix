{ lib, config, pkgs, nixpkgs, ... }:

let
  cfg = config.essentia.common;
in
with lib; {
  options.essentia.common = {
    enable = mkEnableOption "Activate common Nix configuration options";
  };

  config = mkIf cfg.enable {
    nix = {
      package = pkgs.nixUnstable;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
      registry.nixpkgs.flake = nixpkgs;
    };

    nixpkgs.config.allowUnfree = true;
  };
}
