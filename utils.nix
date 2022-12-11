{
  lib,
  inputs,
}:
with lib; rec {
  mkAttrsTree = dir:
    mapAttrs'
    (
      name: type:
        if type == "directory"
        then
          if pathExists /${dir}/${name}/default.nix
          then nameValuePair name /${dir}/${name}/default.nix
          else nameValuePair name (mkAttrsTree /${dir}/${name})
        else nameValuePair (removeSuffix ".nix" name) /${dir}/${name}
    )
    (
      filterAttrs
      (
        name: type:
          type == "directory" || hasSuffix ".nix" name
      )
      (builtins.readDir dir)
    );

  mkOverlayTree = path:
    lib.mapAttrsRecursive (_: ovl: import ovl inputs) (mkAttrsTree path);

  listNixFilesRecursive = path:
    filter (hasSuffix ".nix") (filesystem.listFilesRecursive path);

  mkNixosConfig = path: hostPlatform: name:
    makeOverridable nixosSystem {
      modules =
        [
          {
            networking.hostName = name;
            nixpkgs = {
              inherit hostPlatform;

              overlays = collect (a: !isAttrs a) inputs.self.overlays;
            };
          }
          inputs.nur.nixosModules.nur
          inputs.sops-nix.nixosModules.sops
        ]
        ++ (collect (a: !isAttrs a) inputs.self.nixosModules.nixos)
        ++ listNixFilesRecursive path;

      specialArgs = {
        inherit inputs;
        inherit (inputs.self) nixosModules;
      };
    };

  mkNixosConfigs = hosts:
    foldAttrs (confs: conf: confs // conf) {} (
      map
      (
        arch:
          mapAttrs
          (
            host: type:
              mkNixosConfig /${hosts}/${arch}/${host} arch host
          )
          (builtins.readDir /${hosts}/${arch})
      )
      (attrNames (builtins.readDir hosts))
    );
}
