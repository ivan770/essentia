{config, ...}: {
  services.openssh = {
    enable = true;
    allowSFTP = false;
    passwordAuthentication = false;
    permitRootLogin = "no";
    kbdInteractiveAuthentication = false;
    startWhenNeeded = true;
    extraConfig = ''
      MaxAuthTries 3
    '';
  };

  essentia.server.firewall.protectedPorts = config.services.openssh.ports;
}
