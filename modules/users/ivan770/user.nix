{
  config,
  lib,
  ...
}: {
  users.users.ivan770 = {
    isNormalUser = true;
    passwordFile = config.sops.secrets."users/ivan770/password".path;
    extraGroups =
      [
        "video"
        "wheel"
      ]
      ++ lib.optionals config.security.tpm2.enable [config.security.tpm2.tssGroup]
      ++ lib.optionals config.hardware.sane.enable ["scanner" "lp"];
    openssh.authorizedKeys.keys = [
      (builtins.readFile (builtins.fetchurl {
        url = "https://ssh.ivan770.me";
        sha256 = "1gsrc7pc1i6kx4hi5wskq6ml84pb1hcxqnxkb5qllk5pjg86360m";
      }))
    ];
  };
}
