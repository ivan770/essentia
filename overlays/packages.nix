inputs: self: super:
with super.lib; let
  mkPackageTree = dir:
    mapAttrs'
    (
      name: type:
        if type == "directory"
        then nameValuePair name (mkPackageTree /${dir}/${name})
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
in
  mapAttrsRecursive (path: pkg:
    self.callPackage pkg {
      # FIXME: Support packages nested within nixpkgs (like "gnome.gdm").
      ${head path} = attrByPath path null super;
    }) (mkPackageTree ../packages)
