{ lib, config, pkgs, ... }:

{
  config = lib.mkIf config.nixos-config.desktop.hyprland.enable {
    home-manager.users.${config.nixos-config.username} = {
      wayland.windowManager.hyprland.settings = {
        general = {
          gaps_in = 2;
          gaps_out = 4;
          border_size = 2;
          layout = "dwindle";
        }; 

        decoration = { 
          rounding = 5;
          blur = {
            enabled = true;
            size = 10;
            passes = 3;
            special = true;
          };
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
            "specialWorkspace, 1, 6, default, slidevert"
          ];
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
          special_scale_factor = 1;
        };

        misc = {
          disable_hyprland_logo = true;
          #vrr = 1;
        };

        # XWayland scaling
        xwayland.force_zero_scaling = true;
      };

      services.hyprpaper.enable = true;
      systemd.user.services.hyprpaper.Unit.After = lib.mkForce "graphical-session.target";
    };
  };
}
