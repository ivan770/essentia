{config, ...}: {
  config.users.users.ivan770 = {
    isNormalUser = true;
    home = "/home/ivan770";
    extraGroups = [
      "networkmanager"
      "video"
      "wheel"
      "tss"
    ];
  };
}
