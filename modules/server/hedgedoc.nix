{
  essentia.containers.configurations.hedgedoc = let
    dataDir = "/var/lib/hedgedoc";
  in {
    config = {
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

          allowAnonymous = false;
          csp = {
            allowFraming = false;
            allowPDFEmbed = false;
          };
          db = {
            dialect = "sqlite";
            storage = "${dataDir}/hedgedoc.sqlite";
          };
          defaultPermission = "private";
          host = localAddress;
          port = exposedServices.main;
          protocolUseSSL = true;
        };
      };

      system.stateVersion = "22.05";
    };

    bindSlots.data = dataDir;
    exposedServices.main = 3000;
  };
}
