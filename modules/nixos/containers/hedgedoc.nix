{
  essentia.server = {
    containers.configurations.hedgedoc = let
      dataDir = "/var/lib/hedgedoc";
    in {
      config = {
        connectors,
        domain,
        exposedServices,
        localAddress,
        ...
      }: {
        services.hedgedoc = {
          enable = true;
          workDir = dataDir;
          settings = {
            inherit domain;

            host = localAddress;
            port = exposedServices.main;
            protocolUseSSL = true;

            allowAnonymous = false;
            allowEmailRegister = false;
            allowGravatar = false;
            csp = {
              allowFraming = false;
              allowPDFEmbed = false;
            };
            db = {
              dialect = "postgres";
              host = connectors.postgresql.address;
              port = connectors.postgresql.services.main;
              username = "hedgedoc";
              database = "hedgedoc_main";
            };
            defaultPermission = "private";
          };
        };

        system.stateVersion = "22.11";
      };

      bindSlots.data = dataDir;
      exposedServices = ["main"];
    };

    postgresql.apps.hedgedoc = ["main"];
  };
}
