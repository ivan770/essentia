{
  description = "Essentia NixOS config";

  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };

    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
      ref = "master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      type = "github";
      owner = "NixOS";
      repo = "nixos-hardware";
    };

    flake-utils = {
      type = "github";
      owner = "numtide";
      repo = "flake-utils";
    };
  };

  outputs = inputs:
    let
      inherit (inputs.nixpkgs) lib;
      utils = import ./utils.nix { inherit inputs lib; };
    in
    {
      nixosModules = utils.mkAttrsTree ./modules;
      overlays = utils.mkOverlayTree ./overlays;
      nixosConfigurations = utils.mkNixosConfigs ./hosts;
    };
}
