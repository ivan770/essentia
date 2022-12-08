{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.essentia.logging;
in {
  options.essentia.logging = {
    flavor = mkOption {
      type = types.enum ["volatile" "persistent"];
      default = "volatile";
      description = ''
        Preferred log storage.
      '';
    };

    maxLogSize = mkOption {
      type = types.int;
      default = if cfg.flavor == "volatile"
        then 128
        else 2048;
      defaultText = "if config.essentia.logging.flavor == \"volatile\" then 128 else 2048";
      description = ''
        Upper size limit enforced on journald, in MB.
      '';
    };
  };

  config.services.journald.extraConfig = let
    flavorPrefix = if cfg.flavor == "volatile"
      then "Runtime"
      else "System";
  in ''
    MaxLevelStore=warning

    Storage=${cfg.flavor}
    ${flavorPrefix}MaxUse=${toString cfg.maxLogSize}M
  '';
}
