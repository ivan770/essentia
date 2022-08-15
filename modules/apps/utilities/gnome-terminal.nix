{
  config,
  lib,
  ...
}: let
  cfg = config.essentia.programs.gnome-terminal;
in
  with lib; {
    options.essentia.programs.gnome-terminal = {
      settings = mkOption {
        type = with types; attrsOf (either bool (either int (either str submodule)));
        default = {};
        description = "Preferred GNOME terminal settings";
      };
    };

    config.programs.gnome-terminal = {
      enable = true;
      profile = {
        "312e3564-525a-4321-bb69-6cf8f9c2bd84" =
          cfg.settings
          // {
            default = true;
            visibleName = "Main profile";
          };
      };
    };
  }
