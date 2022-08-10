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

  outputs = { self, nixpkgs, flake-utils, ... } @ inputs:
    {
      nixosModules = builtins.listToAttrs
        (map
          (x: {
            name = x;
            value = import (./modules/${x});
          })
          (builtins.attrNames (builtins.readDir ./modules)))

      //

      {
        home-manager = { config, pkgs, lib, ... }: {
          imports = [ ./home-manager ];
        };
      };

      nixosConfigurations =
        builtins.listToAttrs (builtins.map
          (name: {
            inherit name;
            value = nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              specialArgs = { flake-self = self; } // inputs;
              modules = [
                ./hosts/${name}/configuration.nix
                { networking.hostName = name; }
                { imports = builtins.attrValues self.nixosModules; }
              ];
            };
          })
          (builtins.attrNames (builtins.readDir ./hosts)));
    }

    //

    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in
      {
        formatter = pkgs.nixpkgs-fmt;

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            statix
          ];
        };
      }
    );
}
