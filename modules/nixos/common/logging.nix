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

    maxLogSize = {
      volatile = mkOption {
        type = types.int;
        default = 128;
        description = ''
          Upper size limit enforced on journald's in-memory journal.
        '';
      };

      persistent = mkOption {
        type = types.int;
        default = 2048;
        description = ''
          Upper size limit enforced on journald's persistent journal.
        '';
      };
    };
  };

  config.services = {
    journald.extraConfig = ''
      MaxLevelStore=warning

      Storage=${cfg.flavor}

      RuntimeMaxUse=${toString cfg.maxLogSize.volatile}M
      SystemMaxUse=${toString cfg.maxLogSize.persistent}M
    '';

    # journald has built-in log rotation capabilities
    logrotate.enable = false;
  };
}
