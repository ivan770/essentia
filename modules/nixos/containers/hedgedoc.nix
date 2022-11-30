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
            dialect = "sqlite";
            storage = "${dataDir}/hedgedoc.sqlite";
          };
          defaultPermission = "private";
        };
      };

      system.stateVersion = "22.05";
    };

    bindSlots.data = dataDir;
    exposedServices.main = 3000;
  };
}
