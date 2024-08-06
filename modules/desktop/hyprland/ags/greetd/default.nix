{ pkgs, username, configDir, ... }:
{
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.hyprland}/bin/Hyprland --config ${configDir}/modules/desktop/hyprland/ags/greetd/hyprland.conf";
      user = username;
    };
  };
  environment.etc."greetd/greeter.js".source = ./greeter.js;
}
