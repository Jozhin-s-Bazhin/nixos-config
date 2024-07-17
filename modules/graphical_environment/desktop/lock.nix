{ pkgs, username, architecture, inputs, configDir, ... }:
{
  security.pam.services.gtklock = {};

  home-manager.users.${username} = {
    services.hypridle = {
      enable = true;
      settings = { 
        general = {
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
#!/run/current-system/sw/bin/bash -l

# Environment variables
loginctl_sessions=$(loginctl list-sessions)
export XDG_RUNTIME_DIR="/run/user/$(echo $loginctl_sessions | ${pkgs.gawk}/bin/awk 'NR==2 {print $2}')"
export WAYLAND_DISPLAY="wayland-$(echo $loginctl_sessions | ${pkgs.gawk}/bin/awk 'NR==2 {print $1}')"
export DBUS_SESSION_ADDRESS="unix:path=/run/user/$(echo $loginctl_sessions | ${pkgs.gawk}/bin/awk 'NR==2 {print $2}')/bus"

${pkgs.gtklock}/bin/gtklock -L "systemd-notify --ready"
      ''}/bin/lockBeforeSleep";
    };
  };
  services.logind = {
    powerKey = "hibernate";
    lidSwitch = "suspend";
    lidSwitchExternalPower = "suspend";
    lidSwitchDocked = "suspend";
  };

  # Polkit
  users.users.${username}.packages = [ pkgs.lxqt.lxqt-policykit ];
}
