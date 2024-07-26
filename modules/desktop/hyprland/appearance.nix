{ lib, config, pkgs, username, ... }:

{
  home-manager.users.${username} = {
    wayland.windowManager.hyprland.settings = {
      general = {
        gaps_in = 2;
        gaps_out = 4;
        border_size = 2;
        #"col.active_border" = "rgba(${ colors.nixToHex colors.accent }ff)";
        #"col.inactive_border" = "rgba(${ colors.nixToHex colors.background_darker }ff)";
        layout = "dwindle";
        allow_tearing = true; 
      }; 

      decoration = { 
        rounding = 5;
        blur = {
          enabled = true;
          size = 3;
          passes = 2;
          special = true;
        };

        drop_shadow = false;
        shadow_range = 4;
        shadow_render_power = 3;
        #"col.shadow" = "rgba(1a1a1aee)";
      };

      animations = {
        enabled = true;
        bezier = [ "myBezier, 0.05, 0.9, 0.1, 1.05" ];
        animation = [ 
    "windows, 1, 4, myBezier"
        "windowsOut, 1, 4, default, popin 80%"
        "border, 1, 5, default"
        "borderangle, 1, 4, default"
    "fade, 1, 4, default"
        "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
        special_scale_factor = 1;
      };

      misc = {
        disable_hyprland_logo = true;
        vrr = 1;
      };

      xwayland.force_zero_scaling = true;
    };

    services.hyprpaper.enable = true;
  };
}

