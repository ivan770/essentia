{
  lib,
  name,
  mdIconFont,
  warnColor,
  ...
}: {
  network = let
    mkSignalIcon = text: {
      string = {
        inherit text;
        font = mdIconFont;
      };
    };

    missingCarrier = {
      string = {
        text = "󰅛";
        font = mdIconFont;
        foreground = warnColor;
      };
    };

    wired = {
      carrier = mkSignalIcon "󰈀";
      "~carrier" = missingCarrier;
    };

    wireless = {
      carrier.map = {
        conditions = {
          "signal >= -50" = mkSignalIcon "󰤨";
          "signal >= -67" = mkSignalIcon "󰤥";
          "signal >= -70" = mkSignalIcon "󰤢";
          "signal >= -80" = mkSignalIcon "󰤟";
        };
        default = mkSignalIcon "󰤯";
      };
      "~carrier" = missingCarrier;
    };
  in {
    inherit name;

    content.map.conditions =
      if (lib.hasPrefix "en" name)
      then wired
      else wireless;
  };
}
