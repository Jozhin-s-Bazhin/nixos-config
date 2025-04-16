{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.nixos-config.desktop.hyprland.enable {
    home-manager.users.${config.nixos-config.username}.wayland.windowManager.hyprland = {
      plugins = [
        inputs.hyprtasking.packages.${pkgs.system}.hyprtasking
      ];

      settings.plugin = {
        hyprtasking = {
          layout = "grid";

          gap_size = 10;
          bg_color = "0x00000000";
          border_size = 0;
          exit_behavior = "active interacted original";

          gestures = {
            enabled = true;
            open_fingers = 3;
            open_distance = 200;
            open_positive = true;
          };

          grid = {
            rows = 3;
            columns = 3;
          };

          linear = {
            height = 200;
            scroll_speed = 1.1;
            blur = 0;
          };
        };
      };
    };
  };
}
