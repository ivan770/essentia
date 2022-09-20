{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.essentia.nginx;

  originPullCA = builtins.fetchurl {
    url = "https://developers.cloudflare.com/ssl/static/authenticated_origin_pull_ca.pem";
    sha256 = "0ihxmayis1sxr6lsyc6rb1lv3lassf13csxcgym23p19w6gs43ih";
  };
in
  with lib; {
    options.essentia.nginx = {
      endpoints = mkOption {
        type = types.listOf (types.submodule {
          options = {
            name = mkOption {
              type = types.str;
              description = "Endpoint public hostname";
            };
            port = mkOption {
              type = types.int;
              description = "Endpoint local port";
            };
          };
        });
        description = "Proxied Nginx endpoints";
      };
    };

    config.services.nginx = {
      enable = true;
      recommendedOptimisation = true;
      recommendedTlsSettings = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;

      virtualHosts = builtins.listToAttrs (map (endpoint: {
          name = endpoint.name;
          value = {
            reuseport = true;
            onlySSL = true;
            kTLS = true;
            sslCertificate = config.sops.secrets."ssl/cert".path;
            sslCertificateKey = config.sops.secrets."ssl/key".path;
            locations."/" = {
              proxyPass = "http://localhost:" + toString (endpoint.port) + "/";
              proxyWebsockets = true;
            };
            extraConfig = ''
              ssl_client_certificate ${originPullCA};
              ssl_verify_client on;
            '';
          };
        })
        cfg.endpoints);
    };
  }
