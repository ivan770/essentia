{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.essentia.programs.firefox;
in
  with lib; {
    options.essentia.programs.firefox = {
      extensions = mkOption {
        type = types.listOf types.package;
        default = [];
        description = "Firefox extensions to install";
      };
      settings = mkOption {
        type = with types; attrsOf (either bool (either int str));
        default = {};
        description = "Preferred Firefox settings";
      };
      wayland = mkEnableOption "Enable Firefox Wayland support";
    };

    config = {
      programs.firefox = {
        enable = true;
        package =
          if cfg.wayland
          then pkgs.firefox-wayland
          else pkgs.firefox;
        extensions = cfg.extensions;
        profiles.default = {
          settings =
            cfg.settings
            // {
              # Privacy
              "app.shield.optoutstudies.enabled" = false;
              "browser.discovery.enabled" = false;
              "datareporting.healthreport.uploadEnabled" = false;

              # Bloatware removal
              "extensions.pocket.enabled" = false;

              # Remove disk-based caching
              "browser.cache.disk.enable" = false;
              "browser.cache.disk.smart_size.enabled" = false;
              "browser.cache.disk_cache_ssl" = false;
              "browser.cache.offline.enable" = false;

              # Tune memory-based caching a bit
              "browser.cache.memory.capacity" = 1024000;

              # Disable sync for those items, that are managed
              # by extensions or Nix
              "services.sync.declinedEngines" = "passwords,creditcards,prefs,addons";
              "services.sync.engine.passwords" = false;
              "services.sync.engine.creditcards" = false;
              "services.sync.engine.addons" = false;
              "services.sync.engine.prefs" = false;
              "services.sync.engine.prefs.modified" = false;

              # https://github.com/elFarto/nvidia-vaapi-driver/#firefox
              "media.ffmpeg.vaapi.enabled" = true;
              "media.rdd-ffmpeg.enabled" = true;
              "media.av1.enabled" = false;
              "gfx.x11-egl.force-enabled" = true;
              # In case if VAAPI detection failes force hardware decoding usage.
              "media.hardware-video-decoding.force-enabled" = true;
            };
        };
      };
      systemd.user.sessionVariables = mkMerge [
        {
          # https://github.com/elFarto/nvidia-vaapi-driver/#firefox
          MOZ_DISABLE_RDD_SANDBOX = 1;
        }
        (mkIf cfg.wayland {
          # https://github.com/elFarto/nvidia-vaapi-driver/#firefox
          EGL_PLATFORM = "wayland";
        })
      ];
    };
  }
