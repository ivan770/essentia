inputs: self: super: {
  lib = super.lib.extend (self: super: {
    recursiveMerge = attrList:
      with super; let
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
  });
}
