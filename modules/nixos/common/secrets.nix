{
  config,
  lib,
  ...
}:
with lib; {
  config.sops = {
    defaultSopsFile = ../../../secrets.yaml;
    secrets = mkMerge [
      {
        "users/ivan770/password".neededForUsers = true;
        "users/ivan770/git" = {
          owner = config.users.users.ivan770.name;
          group = config.users.users.ivan770.group;
        };
        trustedNetworks = {};
      }
      (mkIf (config.essentia.server.nginx.activatedUpstreams != {}) {
        "ssl/cert" = {
          owner = config.services.nginx.user;
          group = config.services.nginx.group;
        };
        "ssl/key" = {
          owner = config.services.nginx.user;
          group = config.services.nginx.group;
        };
      })
    ];
  };
}
