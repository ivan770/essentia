{config, ...}: {
  # https://discourse.nixos.org/t/removing-persistent-boot-messages-for-a-silent-boot/14835/10
  config.boot = {
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "boot.shell_on_fail"
    ];
  };
}