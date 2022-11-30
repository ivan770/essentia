{
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
}
