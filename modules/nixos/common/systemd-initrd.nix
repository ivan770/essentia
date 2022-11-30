{
  config,
  lib,
  ...
}: let
  cfg = config.essentia.systemd-initrd;
in
  with lib; {
    options.essentia.systemd-initrd = {
      enable = mkEnableOption "systemd in stage 1 support";
    };

    # FIXME: Make non-configurable as soon as https://github.com/NixOS/nixpkgs/issues/178345 gets resolved.
    config.boot.initrd.systemd.enable = cfg.enable;
  }
