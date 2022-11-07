inputs: self: super: {
  lib = super.lib.extend (selfLib: superLib: {
    recursiveMerge = attrList:
      with superLib; let
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

    partiallyRequireFile = sources: {sha256, ...} @ args:
      if builtins.hasAttr sha256 sources
      then
        builtins.fetchurl {
          inherit sha256;
          url = sources.${sha256};
        }
      else super.requireFile args;

    # Works only in HM profile modules.
    runMenu = config: prompt: let
      cfg = config.essentia.programs.menu;
    in "${cfg.flavor} ${cfg.flags} ${cfg.promptTitleFlag} ${prompt}";
  });
}
