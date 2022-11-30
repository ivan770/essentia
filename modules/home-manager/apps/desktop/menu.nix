{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.essentia.programs.menu;
in
  with lib; {
    options.essentia.programs.menu = {
      flavor = mkOption {
        type = types.str;
        default = "${pkgs.bemenu}/bin/bemenu";
        defaultText = "pkgs.bemenu/bin/bemenu";
        description = ''
          Preferred menu flavor, that will be executed user-wide.
        '';
      };

      flags = mkOption {
        type = types.str;
        default = "--list 10 -c -W 0.5 -f -i";
        description = ''
          Flags to pass to the flavor binary.
        '';
      };

      promptTitleFlag = mkOption {
        type = types.str;
        default = "-p";
        description = ''
          Flag that allows programs to specify prompt title.
        '';
      };
    };
  }
