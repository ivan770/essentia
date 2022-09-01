{...}: {
  sops = {
    defaultSopsFile = ../../secrets.yaml;
    secrets = {
      "users/ivan770/password".neededForUsers = true;
      networks = {};
      "postgresql/ssl/server/cert" = {
        owner = "postgres";
        group = "postgres";
      };
      "postgresql/ssl/server/key" = {
        owner = "postgres";
        group = "postgres";
      };
      "postgresql/ssl/root" = {
        owner = "postgres";
        group = "postgres";
      };
    };
  };
}
