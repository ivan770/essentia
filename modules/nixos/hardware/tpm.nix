{
  config,
  lib,
  ...
}: let
  cfg = config.essentia.tpm;
in
  with lib; {
    options.essentia.tpm = {
      enable = mkEnableOption "TPM2 support";
    };

    config.security.tpm2 = mkIf cfg.enable {
      enable = true;
    };
  }
