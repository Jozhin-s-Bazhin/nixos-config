{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.nixos-config.desktop.hyprland.enable {
    security.pam.services.gtklock.text = ''
      auth            sufficient      pam_unix.so try_first_pass likeauth nullok
    '';

    home-manager.users.${config.nixos-config.username} = {
      services.hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = "fprintd-verify && pkill gtklock & ${pkgs.gtklock}/bin/gtklock -dfHS -U 'pkill fprintd-verify'";
            before_sleep_cmd = "loginctl lock-session; pkill fprintd-verify";
            after_sleep_cmd = "fprintd-verify && pkill gtklock";
          };
          listener = [
            {
              timeout = 840;
              on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -s set 1";
              on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -r";
            }
            {
              timeout = 900;
              on-timeout = "hyprctl dispatch dpms off";
            }
            {
              timeout = 905;
              on-timeout = "${pkgs.systemd}/bin/systemctl suspend";
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
          background-image: url("${config.nixos-config.configDir}/modules/desktop/wallpaper/wallpaper_blurred.jpg");
          background-size: cover;
          background-repeat: no-repeat;
          background-position: center;
        }

        #clock-label, #date-label {
          color: white;
          text-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
          font-weight: 200;
        }

        #clock-label {
          font-size: 150px;
        }

        #date-label {
          font-size: 30px;
        }

        #input-field, #input-label {
          margin-top: 15px;
        }

        #input-label {
          text-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
        }
      '';
    };

    # Enable polkit
    security.polkit.enable = true;
    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    # Map power key to hibernate instead of shutdown
    services.logind = {
      powerKey = "hibernate";
      lidSwitch = "suspend";
    };
    #systemd.sleep.extraConfig = "HibernateDelaySec=3h";

    # Login screen
    services.greetd.settings.default_session.command =
      "env GTK_USE_PORTAL=0 GDK_DEBUG=no-portals ${lib.getExe pkgs.cage} -s -mlast -- ${config.programs.regreet.package}/bin/regreet";
    programs.regreet = {
      enable = true;
      settings.background.path = lib.mkForce config.nixos-config.desktop.theming.blurredWallpaper;
    };
  };
}
