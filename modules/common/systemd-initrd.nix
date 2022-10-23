{
  # FIXME: Move to generic desktop as soon as https://github.com/NixOS/nixpkgs/issues/178345 gets resolved.
  boot.initrd.systemd.enable = true;
}
