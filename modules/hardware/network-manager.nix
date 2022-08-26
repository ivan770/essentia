{config, ...}: {
  config = {
    networking = {
      networkmanager.enable = true;
      resolvconf.enable = false;
      useDHCP = false;
    };
    services.resolved.enable = true;
  };
}
