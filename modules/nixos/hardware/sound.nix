{
  config,
  lib,
  ...
}: let
  cfg = config.essentia.sound;
in
  with lib; {
    options.essentia.sound = {
      enable = mkEnableOption "audio playback support";
    };

    config = mkIf cfg.enable {
      hardware.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
      };
    };
  }
