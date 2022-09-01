{...}: {
  sops = {
    defaultSopsFile = ../../secrets.yaml;
    secrets = {
      "users/ivan770/password".neededForUsers = true;
      networks = {};
      "postgresql/ssl/server/cert" = {};
      "postgresql/ssl/server/key" = {};
      "postgresql/ssl/root" = {};
    };
  };
}
