{config, ...}: {
  config.sops = {
    defaultSopsFile = ../../secrets.yaml;
    secrets = {
      "users/ivan770/password".neededForUsers = true;
      networks = {};
    };
  };
}
