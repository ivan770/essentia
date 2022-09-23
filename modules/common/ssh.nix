{...}: {
  services.openssh = {
    enable = true;
    allowSFTP = false;
    passwordAuthentication = false;
    permitRootLogin = "no";
    kbdInteractiveAuthentication = false;
    useDns = true;
    startWhenNeeded = true;
    extraConfig = ''
      MaxAuthTries 3
    '';
  };
}
