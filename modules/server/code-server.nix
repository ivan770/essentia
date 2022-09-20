{
  config,
  nixosModules,
  ...
}: let
  cfg = config.essentia.code-server;
in
  with lib; {
    options.essentia.code-server = {
      identity = mkOption {
        type = types.str;
        apply = name: assert (name != "root" || abort "Activating Code Server under root is not allowed"); name;
        description = "Identity under which Code Server will be activated";
      };
    };

    config.services.code-server = {
      enable = true;
      user = config.users.users.${cfg.identity}.name;
      group = config.users.users.${cfg.identity}.group;
      # Authentication is expected to be provided by an upstream proxy server.
      auth = "none";
    };
  }
