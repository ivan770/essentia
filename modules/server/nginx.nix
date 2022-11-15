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
        type = types.attrsOf types.str;
        default = {};
        description = ''
          Supported Nginx upstreams.
        '';
      };

      activatedUpstreams = mkOption {
        type = types.attrsOf types.str;
        default = {};
        description = ''
          Activated Nginx upstreams.
        '';
      };
    };

    config = {
      assertions = [
        {
          assertion = let
            activatedUpstreams = filterAttrs (_: value: hasAttr value cfg.upstreams) cfg.activatedUpstreams;
          in
            (attrNames activatedUpstreams) == (attrNames cfg.activatedUpstreams);
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

        upstreams =
          mapAttrs (_: endpoint: {
            servers.${endpoint} = {};
          })
          cfg.upstreams;

        virtualHosts =
          mapAttrs (_: upstream: {
            onlySSL = true;
            kTLS = true;
            sslCertificate = config.sops.secrets."ssl/cert".path;
            sslCertificateKey = config.sops.secrets."ssl/key".path;
            locations."/" = {
              proxyPass = "http://${upstream}";
              proxyWebsockets = true;
            };
            extraConfig = ''
              ssl_client_certificate ${originPullCA};
              ssl_verify_client on;
            '';
          })
          cfg.activatedUpstreams;
      };
    };
  }
