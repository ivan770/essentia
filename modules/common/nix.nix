{
  pkgs,
  inputs,
  ...
}: {
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    settings = {
      auto-optimise-store = true;
      extra-substituters = [
        "https://nixpkgs-unfree.cachix.org"
      ];
      extra-trusted-public-keys = [
        "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
    };

    registry = {
      nixpkgs.flake = inputs.nixpkgs;
      nixpkgs-unfree.flake = inputs.nixpkgs-unfree;
    };

    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];
  };

  nixpkgs.config.allowUnfree = true;
}
