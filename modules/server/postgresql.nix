{config, lib, pkgs, ...}: {
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_14;
    settings = {
      ssl = true;
      ssl_cert_file = config.sops.secrets."postgresql/ssl/server/cert".path;
      ssl_key_file = config.sops.secrets."postgresql/ssl/server/key".path;
      ssl_ca_file = config.sops.secrets."postgresql/ssl/root".path;
    };
    authentication = lib.mkForce ''
      hostssl all all 0.0.0.0/0 cert clientcert=1
    '';
  };
}