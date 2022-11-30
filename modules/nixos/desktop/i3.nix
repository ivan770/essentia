{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.essentia.desktop.i3;
in
  with lib; {
    options.essentia.desktop.i3 = {
      enable = mkEnableOption "i3 desktop support";
    };

    config = mkIf cfg.enable {
      programs.dconf.enable = true;
      services.xserver = {
        enable = true;
        excludePackages = [pkgs.xterm];
        displayManager.startx.enable = true;
      };
      xdg.portal = {
        enable = true;
        extraPortals = [pkgs.xdg-desktop-portal-gtk];
      };
      services = {
        dbus = {
          enable = true;
          packages = [pkgs.gcr];
        };
        greetd = {
          enable = true;
          settings = {
            default_session = {
              command = let
                startx = pkgs.writeShellScript "startx-xsession.sh" ''
                  ${pkgs.xorg.xinit}/bin/startx ~/.xsession -- -keeptty > /dev/null 2>&1
                '';
              in ''
                ${pkgs.greetd.tuigreet}/bin/tuigreet \
                  --time \
                  --cmd ${startx}
              '';
              user = "greeter";
            };
          };
        };
      };
    };
  }
