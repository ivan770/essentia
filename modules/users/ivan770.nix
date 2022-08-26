{
  config,
  lib,
  ...
}:
with lib; {
  config.users.users.ivan770 = {
    isNormalUser = true;
    home = "/home/ivan770";
    extraGroups =
      [
        "video"
        "wheel"
      ]
      ++ optionals config.networking.networkmanager.enable ["networkmanager"]
      ++ optionals config.security.tpm2.enable [config.security.tpm2.tssGroup]
      ++ optionals config.hardware.sane.enable ["scanner" "lp"];
  };
}
