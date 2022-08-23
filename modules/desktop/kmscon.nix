{
  config,
  pkgs,
  ...
}: {
  config.services.kmscon = {
    enable = true;
    hwRender = true;
    fonts = [
      {
        name = "JetBrains Mono";
        package = pkgs.jetbrains-mono;
      }
    ];
  };
}
