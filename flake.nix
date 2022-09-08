{
  description = "Essentia NixOS config";

  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };

    nixpkgs-unfree = {
      type = "github";
      owner = "numtide";
      repo = "nixpkgs-unfree";
      ref = "nixos-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
      ref = "master";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
    };

    nur = {
      type = "github";
      owner = "nix-community";
      repo = "NUR";
      ref = "master";
    };

    nixos-hardware = {
      type = "github";
      owner = "NixOS";
      repo = "nixos-hardware";
    };

    sops-nix = {
      type = "github";
      owner = "Mic92";
      repo = "sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils = {
      type = "github";
      owner = "numtide";
      repo = "flake-utils";
    };
  };

  outputs = inputs: let
    inherit (inputs.nixpkgs) lib;
    utils = import ./utils.nix {inherit inputs lib;};
  in
    {
      nixosModules = utils.mkAttrsTree ./modules;
      overlays = utils.mkOverlayTree ./overlays;
      nixosConfigurations = utils.mkNixosConfigs ./hosts;
    }
    // inputs.flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import inputs.nixpkgs {
          inherit system;
        };
      in {
        formatter = pkgs.alejandra;
      }
    );
}
