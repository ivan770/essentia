{config, ...}: {
  config.services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
    kbdInteractiveAuthentication = false;
    startWhenNeeded = true;
  };
}
