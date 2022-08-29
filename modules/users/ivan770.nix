{
  config,
  lib,
  mkUser,
  ...
}:
with lib; {
  config = mkUser {
    inherit config;

    name = "ivan770";
    groups =
      [
        "video"
        "wheel"
      ]
      ++ optionals config.networking.networkmanager.enable ["networkmanager"]
      ++ optionals config.security.tpm2.enable [config.security.tpm2.tssGroup]
      ++ optionals config.hardware.sane.enable ["scanner" "lp"];
    sshKey = builtins.readFile (builtins.fetchurl {
      url = "https://ssh.ivan770.me";
      sha256 = "0ihxmayis1sxr6lsyc6rb1lv3lassf13csxcgym23p19w6gs43ih";
    });
  };
}
