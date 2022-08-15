{ config, lib, pkgs, ... }:

let
  cfg = config.essentia.programs.gpg;
in
with lib; {
  options.essentia.programs.gpg = {
    pinentryFlavor = mkOption {
      type = types.nullOr (types.enum pkgs.pinentry.flavors);
      default = "gnome3";
      example = "gtk2";
      description = "Pinentry flavor value to pass to gpg-agent.conf";
    };

    sshKeys = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = null;
      description = ''
        Which GPG keys (by keygrip) to expose as SSH keys.
      '';
    };
  };

  config = {
    programs.gpg.enable = true;
    services.gpg-agent = mkMerge [
      {
        enable = true;
        enableExtraSocket = true;
        pinentryFlavor = cfg.pinentryFlavor;
      }
      (mkIf (isList cfg.sshKeys) {
        enableSshSupport = true;
        sshKeys = cfg.sshKeys;
      })
    ];
  };
}
