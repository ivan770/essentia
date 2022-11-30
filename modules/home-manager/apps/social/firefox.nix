{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.essentia.programs.firefox;

  mkFirefoxWrapper = lib.makeOverridable (browser:
    pkgs.symlinkJoin {
      name = "ess-firefox";

      paths = [browser];

      nativeBuildInputs = builtins.attrValues {
        inherit (pkgs) makeWrapper;
      };

      strictDeps = true;

      postBuild = ''
        wrapProgram $out/bin/firefox \
          --set MOZ_DISABLE_RDD_SANDBOX 1 \
          --set MOZ_X11_EGL 1
      '';
    });
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
    };

    config.programs.firefox = {
      enable = true;
      package = mkFirefoxWrapper pkgs.firefox;
      extensions = cfg.extensions;
      profiles.default = {
        settings =
          cfg.settings
          // {
            # General privacy
            "app.normandy.api_url" = "";
            "app.normandy.enabled" = false;
            "app.shield.optoutstudies.enabled" = false;
            "beacon.enabled" = false;
            "breakpad.reportURL" = "";
            "browser.crashReports.unsubmittedCheck.autoSubmit" = false;
            "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
            "browser.crashReports.unsubmittedCheck.enabled" = false;
            "browser.discovery.enabled" = false;
            "browser.send_pings" = false;
            "browser.tabs.crashReporting.sendReport" = false;
            "datareporting.healthreport.service.enabled" = false;
            "datareporting.healthreport.uploadEnabled" = false;
            "datareporting.policy.dataSubmissionEnabled" = false;
            "experiments.enabled" = false;
            "experiments.activeExperiment" = false;
            "experiments.manifest.uri" = "";
            "experiments.supported" = false;
            "extensions.getAddons.cache.enabled" = false;
            "extensions.getAddons.showPane" = false;
            "extensions.shield-recipe-client.enabled" = false;
            "extensions.shield-recipe-client.api_url" = "";
            "network.allow-experiments" = false;
            "services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsoredTopSite" = false;
            "toolkit.telemetry.enabled" = false;
            "toolkit.telemetry.firstShutdownPing.enabled" = false;
            "toolkit.telemetry.hybridContent.enabled" = false;
            "toolkit.telemetry.newProfilePing.enabled" = false;
            "toolkit.telemetry.prompted" = 2;
            "toolkit.telemetry.rejected" = true;
            "toolkit.telemetry.reportingpolicy.firstRun" = false;
            "toolkit.telemetry.server" = "";
            "toolkit.telemetry.shutdownPingSender.enabled" = false;
            "toolkit.telemetry.unified" = false;
            "toolkit.telemetry.unifiedIsOptIn" = false;
            "toolkit.telemetry.updatePing.enabled" = false;

            # Privacy by removal of device-specific APIs
            "device.sensors.enabled" = false;
            "device.sensors.ambientLight.enabled" = false;
            "device.sensors.motion.enabled" = false;
            "device.sensors.orientation.enabled" = false;
            "device.sensors.proximity.enabled" = false;
            "dom.battery.enabled" = false;

            # Bloatware removal
            "extensions.pocket.enabled" = false;
            "reader.parse-on-load.enabled" = false;

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

            # Disable auto-updates since those are managed by Nix anyway
            "app.update.auto" = false;

            # Configuration is expected to always be up-to-date, so remove Firefox suggestion
            # to reset configuration
            "browser.disableResetPrompt" = true;

            # Disable bundled DoH since system is expected to have system-wide secure DNS already
            "network.trr.mode" = 5;

            # https://github.com/elFarto/nvidia-vaapi-driver/#firefox
            "media.ffmpeg.vaapi.enabled" = true;
            "media.rdd-ffmpeg.enabled" = true;
            "media.av1.enabled" = false;

            # Enable VA-API decoding for WebRTC
            "media.navigator.mediadatadecoder_vpx_enabled" = true;
          };
      };
    };
  }
