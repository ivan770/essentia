{config, ...}: {
  services.code-server = {
    enable = true;
    # FIXME: Hardcoded for now
    user = config.users.users.ivan770.name;
    group = config.users.users.ivan770.group;
    # Authentication is expected to be provided by an upstream proxy server.
    auth = "none";
  };
}
