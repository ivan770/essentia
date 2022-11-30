{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.essentia.desktop;
in
  with lib; {
    options.essentia.desktop = {
      enable = mkEnableOption "generic desktop configuration";
    };

    config = mkIf cfg.enable {
      console.earlySetup = true;

      # Required for default system-wide fonts configuration.
      # See fonts.fontconfig.defaultFonts.* for more information.
      fonts.fonts = builtins.attrValues {
        inherit (pkgs) dejavu_fonts noto-fonts-emoji;
      };

      boot = {
        # https://discourse.nixos.org/t/removing-persistent-boot-messages-for-a-silent-boot/14835/10
        consoleLogLevel = 0;
        initrd.verbose = false;

        kernelParams = [
          "quiet"
          "rd.systemd.show_status=false"
          "rd.udev.log_level=3"
          "udev.log_priority=3"
          "boot.shell_on_fail"

          "mitigations=off"
          "nowatchdog"
          "nmi_watchdog=0"
        ];

        plymouth.enable = true;
      };
    };
  }
