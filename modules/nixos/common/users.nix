{lib, ...}:
with lib; {
  options.essentia.users = {
    activated = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        Activated user configurations.
      '';
    };
  };
}
