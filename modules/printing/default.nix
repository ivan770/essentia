{ lib, config, ... }:

let
  cfg = config.essentia.printing;
in
with lib; {
  options.essentia.printing = {
    enable = mkEnableOption "Activate printing support";
  };

  config = mkIf cfg.enable {
    services.printing = {
      enable = true;
      webInterface = false;
    };
  };
}
