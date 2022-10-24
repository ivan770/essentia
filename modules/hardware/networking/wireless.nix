{
  config,
  lib,
  nixosModules,
  ...
}:
with lib; let
  cfg = config.essentia.networking.wireless;
in {
  options.essentia.networking.wireless = {
    networks = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        Known wireless networks. If empty list is provided, wireless networking capabilities will be disabled
      '';
    };
  };

  config.networking.wireless = mkIf (cfg.networks != []) {
    enable = true;
    environmentFile = config.sops.secrets.networks.path;
    networks = builtins.listToAttrs (map (name: {
        inherit name;
        value = {
          pskRaw = "@${strings.toUpper (replaceStrings ["-"] ["_"] name)}@";
        };
      })
      cfg.networks);
    dbusControlled = false;
    scanOnLowSignal = false;
  };
}
