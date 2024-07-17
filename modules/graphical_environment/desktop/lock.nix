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
hyprland_pid=$(pgrep -u $USER Hyprland)

_zedlmt() { od -t x1 -w1 -v  | sed -n '
    /.* \(..\)$/s//\1/
    /00/!{H;b};s///
    x;s/\n/\\x/gp;x;h'
}

_pidenv() { ps -p $1 >/dev/null 2>&1 &&
        [ -z "${1#"$psrc"}" ] && . /dev/fd/3 ||
        cat <&3 ; unset psrc pcat
} 3<<STATE
        $( [ -z "${1#${pcat=$psrc}}" ] &&
        pcat='$(printf %%b "%s")' || pcat="%b"
        xeq="$(printf '\\\\x%x' "'=")"
        for x in $( _zedlmt </proc/$1/environ ) ; do
        printf "%b=$pcat\n" "${x%%"$xeq"*}" "${x#*"$xeq"}"
        done)
STATE

_pidenv 2493 > file

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
