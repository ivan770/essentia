{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.essentia.programs.mpv;

  mpvOption = with lib.types; either str (either int (either bool float));
  mpvOptionDup = with lib.types; either mpvOption (listOf mpvOption);
  mpvOptions = with lib.types; attrsOf mpvOptionDup;
in
  with lib; {
    options.essentia.programs.mpv = {
      userProfile = mkOption {
        type = mpvOptions;
        default = {};
        description = "User-specific mpv configuration";
      };

      activatedProfiles = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Activated mpv profiles";
      };
    };

    config.programs.mpv = {
      enable = true;
      package =
        pkgs.wrapMpv (pkgs.mpv-unwrapped.override {
          alsaSupport = false;
          bluraySupport = false;
          dvdnavSupport = false;
          javascriptSupport = false;
          screenSaverSupport = false;
        }) {
          youtubeSupport = false;
        };
      config = cfg.userProfile;
      defaultProfiles = cfg.activatedProfiles;
      profiles = {
        audio-normalization = {
          volume = 60;
        };
        large-cache-buffer = {
          cache = "yes";
          demuxer-max-bytes = "1800M";
          demuxer-max-back-bytes = "1200M";
        };
        nvidia = {
          vo = "gpu";
          hwdec = "nvdec";
        };
      };
    };
  }
