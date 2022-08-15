{
  lib,
  config,
  pkgs,
  ...
}: {
  config.services.printing = {
    enable = true;
    webInterface = false;
    drivers = with pkgs; [
      gutenprint
      gutenprintBin
    ];
  };
}
