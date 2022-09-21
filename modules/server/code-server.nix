{...}: {
  services.code-server = {
    enable = true;
    # FIXME: Hardcoded for now
    user = "ivan770";
    group = "users";
    # Authentication is expected to be provided by an upstream proxy server.
    auth = "none";
  };
}
