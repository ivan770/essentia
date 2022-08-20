{config, ...}: {
  config.networking = {
    networkmanager.enable = true;
    useDHCP = false;
  };
}
