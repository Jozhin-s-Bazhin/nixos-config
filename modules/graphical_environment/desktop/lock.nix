{ pkgs, username, architecture, inputs, configDir, ... }:
{
  
  security.pam.services.gtklock = {}; /*text = ''
    auth            sufficient      pam_unix.so try_first_pass likeauth nullok
    auth            sufficient      pam_fprintd.so
  '';*/
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
export WAYLAND_DISPLAY="wayland-$(loginctl list-sessions | ${pkgs.gawk}/bin/awk 'NR==2 {print $1}')"

${pkgs.gtklock}/bin/gtklock -L "systemd-notify --ready"
      ''}/bin/lockBeforeSleep";
    };
  };

  users.users.${username}.packages = [ pkgs.lxqt.lxqt-policykit ];
}
