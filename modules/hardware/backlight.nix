{pkgs, ...}: {
  programs.light.enable = true;
  services.acpid = {
    enable = true;
    handlers = {
      brightnessUp = {
        event = "video/brightnessup";
        action = "${pkgs.light}/bin/light -A 5";
      };
      brightnessDown = {
        event = "video/brightnessdown";
        action = "${pkgs.light}/bin/light -U 5";
      };
    };
  };
}
