{pkgs, ...}: {
  # FIXME: Move this to hm-sway if possible
  environment.systemPackages = with pkgs; [
    bemenu
  ];
  xdg.portal = {
    enable = true;
    wlr = {
      enable = true;
      settings = {
        screencast = {
          max_fps = 30;
          chooser_type = "dmenu";
          chooser_cmd = "${pkgs.bemenu}/bin/bemenu --list 10 -c -W 0.5 -f";
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
}
