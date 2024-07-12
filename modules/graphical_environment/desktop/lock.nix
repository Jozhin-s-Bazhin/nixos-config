{ pkgs, username, architecture, inputs, configDir, ... }:
{
  security.pam.services.gtklock = {};

  home-manager.users.${username} = {
    services.hypridle = {
      enable = true;
      settings = { general = {
          lock_cmd = "gtklock";
	  #before_sleep_cmd = "gtklock";
        };
        listener = [
          {
            timeout = 840;
            on-timeout = "brightnessctl -s set 1";
            on-resume = "brightnessctl -r";
          }
          {
            timeout = 900;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
    
    home.packages = with pkgs; [
      brightnessctl
      wirelesstools
      montserrat
      nerdfonts
      gtklock
    ];
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
      User = username;
      ExecStart = "${pkgs.writeScriptBin "lockBeforeSleep" ''
#!/run/current-system/sw/bin/bash

# Environment variables for gtklock
export XDG_RUNTIME_DIR="/run/user/$(loginctl list-sessions | ${pkgs.gawk}/bin/awk 'NR==2 {print $2}')"
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus

${pkgs.dbus}/bin/dbus-run-session --dbus-daemon ${pkgs.dbus}/bin/dbus-daemon -- ${pkgs.gtklock}/bin/gtklock -d -L "systemd-notify --ready" --display="wayland-$(loginctl list-sessions | ${pkgs.gawk}/bin/awk 'NR==2 {print $1}')"

      ''}/bin/lockBeforeSleep";
    };
  };

  # Polkit
  users.users.${username}.packages = [ pkgs.lxqt.lxqt-policykit ];
}
