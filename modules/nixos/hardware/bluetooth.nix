{
  config,
  lib,
  ...
}: let
  cfg = config.essentia.bluetooth;
in
  with lib; {
    options.essentia.bluetooth = {
      enable = mkEnableOption "Bluetooth support";
    };

    config = mkIf cfg.enable {
      hardware.bluetooth.enable = true;

      # https://nixos.wiki/wiki/PipeWire#Bluetooth_Configuration
      environment.etc."wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
        bluez_monitor.properties = {
          ["bluez5.enable-sbc-xq"] = true,
          ["bluez5.enable-msbc"] = true,
          ["bluez5.enable-hw-volume"] = true,
          ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
        }
      '';
    };
  }
