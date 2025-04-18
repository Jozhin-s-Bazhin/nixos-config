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
        #pkgs.hyprlandPlugins.hyprspace
        #inputs.hyprtasking.packages.${pkgs.system}.hyprtasking
      ];

      settings.plugin = {
        hyprtasking = {
          layout = "linear";

          gap_size = 20;
          bg_color = "0x00000000";
          border_size = 2;
          exit_behavior = [
            "active"
            "interacted"
            "original"
            "hovered"
          ];

          gestures = {
            enabled = true;
            open_fingers = 3;
            open_distance = 300;
            open_positive = true;
          };

          linear = {
            height = 400;
            scroll_speed = 1.1;
            blur = 1;
          };
        };
      };
    };
  };
}
