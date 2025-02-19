{
  lib,
  config,
  pkgs,
  ...
}:

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
          shadow.enabled = false;
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

        workspace = [
          "w[tv1], gapsout:0, gapsin:0"
          "f[1], gapsout:0, gapsin:0"
        ];

        windowrulev2 = [
          "bordersize 0, floating:0, onworkspace:w[tv1]"
          "rounding 0, floating:0, onworkspace:w[tv1]"
          "bordersize 0, floating:0, onworkspace:f[1]"
          "rounding 0, floating:0, onworkspace:f[1]"
        ];

        misc = {
          disable_hyprland_logo = true;
          vrr = 1;
          middle_click_paste = false;
          disable_autoreload = true;
        };

        # XWayland scaling
        xwayland.force_zero_scaling = true;
      };

      services.hyprpaper.enable = true;
      systemd.user.services.hyprpaper.Unit.After = lib.mkForce "graphical-session.target";
    };
  };
}
