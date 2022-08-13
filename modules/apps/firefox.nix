{ config, lib, pkgs, ... }:

let
  cfg = config.essentia.programs.firefox;
in
with lib; {
  options.essentia.programs.firefox = {
    wayland = mkEnableOption "Enable Firefox Wayland support";
  };

  config = mkMerge [
    {
      home.packages = [ pkgs.firefox ];
      systemd.user.sessionVariables = {
        # https://github.com/elFarto/nvidia-vaapi-driver/#firefox
        MOZ_DISABLE_RDD_SANDBOX = 1;
      };
    }
    (mkIf cfg.wayland {
      systemd.user.sessionVariables = {
        MOZ_ENABLE_WAYLAND = 1;
        # https://github.com/elFarto/nvidia-vaapi-driver/#firefox
        EGL_PLATFORM = "wayland";
      };
    })
  ];
}
