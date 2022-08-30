{pkgs, ...}: {
  hardware.sane.enable = true;
  services.printing = {
    enable = true;
    webInterface = false;
    drivers = with pkgs; [
      gutenprint
      gutenprintBin
    ];
  };
}
