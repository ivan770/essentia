{
  lib,
  config,
  ...
}: let
  cfg = config.essentia.secrets;
in
  with lib; {
    options.essentia.secrets = {
      ssl = mkEnableOption "ssl secrets needed for nginx";
    };

    config.sops = {
      defaultSopsFile = ../../secrets.yaml;
      secrets = mkMerge [
        {
          "users/ivan770/password".neededForUsers = true;
          "users/ivan770/git" = {
            owner = config.users.users.ivan770.name;
            group = config.users.users.ivan770.group;
          };
          networks = {};
          trustedNetworks = {};
        }
        (mkIf cfg.ssl {
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
