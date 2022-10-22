{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.essentia.nginx;

  originPullCA = builtins.fetchurl {
    url = "https://developers.cloudflare.com/ssl/static/authenticated_origin_pull_ca.pem";
    sha256 = "0hxqszqfzsbmgksfm6k0gp0hsx9k1gqx24gakxqv0391wl6fsky1";
  };
in
  with lib; {
    options.essentia.nginx = {
      upstreams = mkOption {
        type = types.listOf (types.submodule {
          options = {
            name = mkOption {
              type = types.str;
              description = ''
                Upstream's unique identifier.
              '';
            };
            endpoint = mkOption {
              type = types.str;
              description = ''
                Endpoint, to which Nginx will proxy incoming requests.
              '';
            };
          };
        });
        default = [];
        description = "Supported Nginx upstreams";
      };

      activatedUpstreams = mkOption {
        type = types.listOf (types.submodule {
          options = {
            name = mkOption {
              type = types.str;
              description = ''
                Upstream's public hostname.
              '';
            };
            upstream = mkOption {
              type = types.str;
              description = ''
                Identifier of an upstream, to which Nginx will proxy incoming requests.
              '';
            };
          };
        });
        default = [];
        description = ''
          Activated Nginx upstreams.
        '';
      };
    };

    config = {
      assertions = [
        {
          assertion = all (activatedUpstream: elem activatedUpstream.upstream (map (upstream: upstream.name) cfg.upstreams)) cfg.activatedUpstreams;
          message = ''
            Only upstreams defined via config.essentia.nginx.upstreams can be activated via config.essentia.nginx.activatedUpstreams
          '';
        }
      ];

      services.nginx = {
        enable = true;
        recommendedOptimisation = true;
        recommendedTlsSettings = true;
        recommendedGzipSettings = true;
        recommendedProxySettings = true;

        upstreams = listToAttrs (map (upstream: {
            inherit (upstream) name;
            value.servers = {${upstream.endpoint} = {};};
          })
          cfg.upstreams);

        virtualHosts = listToAttrs (map (activatedUpstream: {
            inherit (activatedUpstream) name;
            value = {
              onlySSL = true;
              kTLS = true;
              sslCertificate = config.sops.secrets."ssl/cert".path;
              sslCertificateKey = config.sops.secrets."ssl/key".path;
              locations."/" = {
                proxyPass = "http://${activatedUpstream.upstream}";
                proxyWebsockets = true;
              };
              extraConfig = ''
                ssl_client_certificate ${originPullCA};
                ssl_verify_client on;
              '';
            };
          })
          cfg.activatedUpstreams);
      };
    };
  }
