{
  essentia.containers.configurations.hedgedoc = let
    dataDir = "/var/lib/hedgedoc";
  in {
    config = {
      domain,
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
          protocolUseSSL = true;
        };
      };

      system.stateVersion = "22.05";
    };

    bindSlots.data = dataDir;
  };
}
