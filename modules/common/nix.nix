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

    settings.trusted-users = [
      "root"
      "@wheel"
    ];

    registry.nixpkgs.flake = inputs.nixpkgs;

    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];
  };

  nixpkgs.config.allowUnfree = true;
}
