{
  keybindings = let
    toggleInDirection = direction: ''
      :{{
        toggle
        ${direction}
      }}
    '';
  in {
    w = "up";
    a = "updir";
    s = "down";
    d = "open";

    W = toggleInDirection "up";
    S = toggleInDirection "down";

    "<c-x>" = "cut";
    "<c-c>" = "copy";
    "<c-v>" = ''
      :{{
        paste
        clear
      }}
    '';

    "<f-2>" = "rename";
    "<delete>" = "delete";

    q = "quit";
    "<c-r>" = "reload";
  };
  settings = {
    hidden = true;
    preview = false;
    ratios = "1:2";
  };
  extraConfig = ''
    set autoquit
  '';
}
