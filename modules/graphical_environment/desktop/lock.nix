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
_zedlmt() { ${pkgs.coreutils}/bin/od -t x1 -w1 -v  | ${pkgs.coreutils}/bin/sed -n '
    /.* \(..\)$/s//\1/
    /00/!{H;b};s///
    x;s/\n/\\x/gp;x;h'
}

_pidenv() { ${pkgs.procps}/bin/ps -p $1 >/dev/null 2>&1 &&
        [ -z "''${1#"$psrc"}" ] && . /dev/fd/3 ||
        ${pkgs.coreutils}/bin/cat <&3 ; unset psrc pcat
} 3<<STATE
        $( [ -z "''${1#''${pcat=$psrc}}" ] &&
        pcat='$(printf %%b "%s")' || pcat="%b"
        xeq="$(printf '\\x%x' "'=")"
        for x in $( _zedlmt </proc/$1/environ ) ; do
        printf "%b=$pcat\n" "''${x%%"$xeq"*}" "''${x#*"$xeq"}"
        done)
#END
STATE
_pidenv ''${psrc=$(pgrep -u $USER Hyprland)}
_pidenv $(pgrep -u $USER Hyprland) > /home/roman/locklogfile

export XDG_RUNTIME_DIR="/run/user/$(loginctl list-sessions | /nix/store/a5rvjq2ir4d1wnxwdf4a9zf6hfc6ydsx-gawk-5.2.2/bin/awk 'NR==2 {print $2}')"
export WAYLAND_DISPLAY="wayland-$(loginctl list-sessions | /nix/store/a5rvjq2ir4d1wnxwdf4a9zf6hfc6ydsx-gawk-5.2.2/bin/awk 'NR==2 {print $1}')"

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
