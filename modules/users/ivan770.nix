{
  config,
  lib,
  ...
}:
with lib; {
  config = {
    sops.secrets."users/ivan770/password".neededForUsers = true;
    users.mutableUsers = false;

    users.users.ivan770 = {
      isNormalUser = true;
      home = "/home/ivan770";
      passwordFile = config.sops.secrets."users/ivan770/password".path;
      extraGroups =
        [
          "video"
          "wheel"
        ]
        ++ optionals config.networking.networkmanager.enable ["networkmanager"]
        ++ optionals config.security.tpm2.enable [config.security.tpm2.tssGroup]
        ++ optionals config.hardware.sane.enable ["scanner" "lp"];
      openssh.authorizedKeys.keys = [
        (builtins.readFile (builtins.fetchurl {
          url = "https://ssh.ivan770.me";
          sha256 = "0ihxmayis1sxr6lsyc6rb1lv3lassf13csxcgym23p19w6gs43ih";
        }))
      ];
    };
  };
}
