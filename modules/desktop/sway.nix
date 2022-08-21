{
  config,
  pkgs,
  ...
}: {
  config = {
    xdg.portal = {
      enable = true;
      gtkUsePortal = true;
      wlr = {
        enable = true;
        # TODO: Provide screencast settings later
      };
    };
    programs.sway.enable = true;
    services = {
      dbus = {
        enable = true;
        packages = [pkgs.gcr];
      };
      greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
            user = "greeter";
          };
        };
      };
    };
  };
}
