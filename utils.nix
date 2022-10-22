{
  lib,
  inputs,
}:
with lib; rec {
  recursiveMerge = attrList: let
    f = attrPath:
      zipAttrsWith (
        n: values:
          if tail values == []
          then head values
          else if all isList values
          then unique (concatLists values)
          else if all isAttrs values
          then f (attrPath ++ [n]) values
          else last values
      );
  in
    f [] attrList;

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

  mkNixosConfig = path: system: name:
    makeOverridable nixosSystem {
      inherit system;

      modules =
        [
          {
            networking.hostName = name;
            nixpkgs.overlays = mkIf (inputs.self ? overlays) (
              collect (a: !isAttrs a) inputs.self.overlays
            );
          }
          inputs.nur.nixosModules.nur
          inputs.sops-nix.nixosModules.sops
        ]
        ++ listNixFilesRecursive path;

      specialArgs =
        optionalAttrs (inputs.self ? nixosModules)
        {
          inherit (inputs.self) nixosModules;
        }
        // {inherit inputs recursiveMerge;};
    };

  mkNixosConfigs = dir:
    foldAttrs (confs: conf: confs // conf) {} (
      map
      (
        arch:
          mapAttrs
          (
            host: type:
              mkNixosConfig /${dir}/${arch}/${host} arch host
          )
          (builtins.readDir /${dir}/${arch})
      )
      (attrNames (builtins.readDir dir))
    );
}
