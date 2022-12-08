{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.essentia.programs.discord;

  jsonFormat = pkgs.formats.json {};
  configFile = jsonFormat.generate "discord.json" cfg.settings;
in
  with lib; {
    options.essentia.programs.discord = {
      settings = mkOption {
        type = jsonFormat.type;
        default = {};
        example = literalExpression ''
          {
            SKIP_HOST_UPDATE = true;
          }
        '';
        description = ''
          Configuration written to
          <filename>$XDG_CONFIG_HOME/discord/settings.json</filename>.
        '';
      };
    };

    config = {
      home.packages = [pkgs.discord];

      essentia.home-impermanence.directories = mkOptionDefault [
        ".config/discord"
      ];

      xdg.configFile."discord/settings.json".source = configFile;
    };
  }
