{ config, pkgs, inputs, ... }:

{
  config = {
    nix = {
      package = pkgs.nixUnstable;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
      settings.trusted-users = [
        "root"
        "@wheel"
      ];
      registry.nixpkgs.flake = inputs.nixpkgs;
    };

    nixpkgs.config.allowUnfree = true;
  };
}
