{
  config,
  lib,
  mdIconFont,
  pkgs,
  spacing,
  ...
}: {
  label.content.string = {
    text = "󰍃";
    font = mdIconFont;
    right-margin = spacing;
    on-click = pkgs.writeShellScript "generate-powermenu.sh" ''
      case "$(echo -e "Shutdown\nRestart\nSuspend\nLogout" | ${lib.runMenu config "Power:"})" in
          Shutdown) exec systemctl poweroff;;
          Restart) exec systemctl reboot;;
          Suspend) exec systemctl suspend;;
          Logout) exec loginctl terminate-user $USER;;
      esac
    '';
  };
}
