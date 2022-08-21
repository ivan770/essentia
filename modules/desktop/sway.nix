{
  config,
  pkgs,
  ...
}: {
  config = {
    # FIXME: Move this to hm-sway if possible
    environment.systemPackages = with pkgs; [
      slurp
      jq
    ];
    xdg.portal = {
      enable = true;
      gtkUsePortal = true;
      wlr = {
        enable = true;
        settings = {
          screencast = {
            max_fps = 30;
            chooser_type = "simple";
            chooser_cmd = ''
              ${pkgs.sway}/bin/swaymsg -t get_tree | ${pkgs.jq}/bin/jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | ${pkgs.slurp}/bin/slurp
            '';
          };
        };
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
