{ config, lib, ... }:

let
  cfg = config.essentia.programs.gnome-terminal;
in
with lib; {
  options.essentia.programs.gnome-terminal = {
    settings = mkOption {
      type = with types; attrsOf (either bool (either int (either str submodule)));
      default = { };
      description = "Preferred GNOME terminal settings";
    };
  };

  config.programs.gnome-terminal = {
    enable = true;
    profile = {
      main = cfg.settings // {
        default = true;
        visibleName = "Main profile";
      };
    };
  };
}
