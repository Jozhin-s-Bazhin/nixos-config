{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.nixos-config.desktop.hyprland.enable {
    security.pam.services.gtklock.text = builtins.readFile "${pkgs.gtklock}/etc/pam.d/gtklock";

    home-manager.users.${config.nixos-config.username} = {
      services.hypridle = {
        enable = true;
        settings = {
          general.lock_cmd = "${pkgs.gtklock}/bin/gtklock";
          listener = [
            {
              timeout = 840;
              on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -s set 1";
              on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -r";
            }
            {
              timeout = 900;
              on-timeout = "${pkgs.brightnessctl}/bin/systemctl suspend";
            }
          ];
        };
      };
      systemd.user.services.hypridle.Unit.After = lib.mkForce "graphical-session.target";

      xdg.configFile."gtklock/config.ini".text = ''
        [main]
        style=/home/${config.nixos-config.username}/.config/gtklock/style.css
      '';
      xdg.configFile."gtklock/style.css".text = ''
        window {
          background-image: url("${config.nixos-config.configDir}/modules/desktop/wallpaper/wallpaper_blurred.png");
          background-size: cover;
          background-repeat: no-repeat;
          background-position: center;
        }

        #clock-label {
          font-size: 100px;
        }
      '';

      wayland.windowManager.hyprland.settings.exec-once = [ "lxqt-policykit-agent" ];
    };

    # Lock screen before sleeping
    systemd.services.lockBeforeSleep = {
      enable = true;
      description = "Lock the screen before sleeping";
      before = [ "sleep.target" ];
      wantedBy = [ "sleep.target" ];
      serviceConfig = {
        Type = "notify";
        NotifyAccess = "all";
        User = config.nixos-config.username;
        ExecStart = "${pkgs.writers.writeBash "lockBeforeSleep" ''
          # Environment variables
          loginctl_sessions=$(loginctl list-sessions)
          export XDG_RUNTIME_DIR="/run/user/$(echo "$loginctl_sessions" | ${pkgs.gawk}/bin/awk 'NR==2 {print $2}')"
          export DBUS_SESSION_ADDRESS="unix:path=/run/user/$(echo "$loginctl_sessions" | ${pkgs.gawk}/bin/awk 'NR==2 {print $2}')/bus"

          ${pkgs.gtklock}/bin/gtklock -L "systemd-notify --ready" --display "wayland-1"
        ''}";
      };
    };

    # Map power key to hibernate instead of shutdown
    services.logind = {
      powerKey = "hibernate";
      lidSwitch = "suspend";
    };
    #systemd.sleep.extraConfig = "HibernateDelaySec=3h";

    # Polkit
    users.users.${config.nixos-config.username}.packages = [ pkgs.lxqt.lxqt-policykit ];

    # Login screen
    services.greetd.settings.default_session.command =
      "env GTK_USE_PORTAL=0 GDK_DEBUG=no-portals ${lib.getExe pkgs.cage} -s -mlast -- ${config.programs.regreet.package}/bin/regreet";
    programs.regreet = {
      enable = true;
      settings.background.path = lib.mkForce config.nixos-config.desktop.theming.blurredWallpaper;
    };
  };
}
