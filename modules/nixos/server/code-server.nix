{
  config,
  lib,
  ...
}: let
  cfg = config.essentia.server.code-server;
in
  with lib; {
    options.essentia.server.code-server = {
      enable = mkEnableOption "code-server support";
    };

    config = mkIf cfg.enable {
      services.code-server = {
        enable = true;
        # FIXME: Hardcoded for now
        user = "ivan770";
        group = "users";
        # Authentication is expected to be provided by an upstream proxy server.
        auth = "none";
      };

      essentia.server.nginx.upstreams.code-server = "${config.services.code-server.host}:${toString config.services.code-server.port}";
    };
  }
