{
  mdIconFont,
  pkgs,
  spacing,
  ...
}: {
  label.content.string = {
    text = "󰍃";
    font = mdIconFont;
    right-margin = spacing;
    on-click = let
      wlogoutStyle = pkgs.writeText "wlogout-style.css" (
        builtins.replaceStrings ["$icons"] ["${pkgs.wlogout}/share/wlogout/icons"] (builtins.readFile ../../wlogout/style.css)
      );
    in
      pkgs.writeShellScript "launch-wlogout.sh" ''
        ${pkgs.wlogout}/bin/wlogout \
          --css ${wlogoutStyle} \
          --layout ${../../wlogout/layout} \
          --buttons-per-row 2 \
          --margin-top 300 \
          --margin-bottom 300 \
          --margin-left 600 \
          --margin-right 600 \
          --protocol layer-shell
      '';
  };
}
