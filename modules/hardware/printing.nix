{pkgs, ...}: {
  hardware.sane.enable = true;
  services.printing = {
    enable = true;
    webInterface = false;
    extraConf = ''
      PreserveJobFiles No
      PreserveJobHistory No
    '';
    drivers = with pkgs; [
      gutenprint
      gutenprintBin
    ];
  };
}
