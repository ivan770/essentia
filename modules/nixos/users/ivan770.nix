{
  config,
  lib,
  ...
}:
with lib; {
  users.users.ivan770 = mkIf (elem "ivan770" config.essentia.users.activated) {
    isNormalUser = true;
    passwordFile = config.sops.secrets."users/ivan770/password".path;
    extraGroups =
      [
        "video"
        "wheel"
      ]
      ++ lib.optionals config.essentia.steam-hardware.enable ["input"]
      ++ lib.optionals config.essentia.tpm.enable [config.security.tpm2.tssGroup]
      ++ lib.optionals config.essentia.printing.enable ["scanner" "lp"]
      ++ lib.optionals config.essentia.desktop.virtualbox.enable ["vboxusers"];
    openssh.authorizedKeys.keys = [
      (builtins.readFile (builtins.fetchurl {
        url = "https://ssh.ivan770.me";
        sha256 = "1gsrc7pc1i6kx4hi5wskq6ml84pb1hcxqnxkb5qllk5pjg86360m";
      }))
    ];
  };
}
