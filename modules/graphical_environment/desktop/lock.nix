{ pkgs, username, architecture, inputs, configDir, config, lib, ... }:
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
    
    home.packages = [
      pkgs.gtklock
    ];

    xdg.configFile."gtklock/config.ini".text = ''
      [main]
      style=/home/${username}/.config/gtklock/style.css
    '';
    xdg.configFile."gtklock/style.css".text = ''
      window {
        background-image: url("${configDir}/modules/graphical_environment/wallpaper/wallpaper_blurred.png");
   	background-size: cover;
   	background-repeat: no-repeat;
   	background-position: center;
      }

      #clock-label {
        font-size: 100px;
      }
    '';
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
export XDG_RUNTIME_DIR="/run/user/$(echo "$loginctl_sessions" | ${pkgs.gawk}/bin/awk 'NR==2 {print $2}')"
export DBUS_SESSION_ADDRESS="unix:path=/run/user/$(echo "$loginctl_sessions" | ${pkgs.gawk}/bin/awk 'NR==2 {print $2}')/bus"

${pkgs.gtklock}/bin/gtklock -L "bash -c 'sleep 1; systemd-notify --ready'" --display "wayland-1"
      ''}/bin/lockBeforeSleep";
    };
  };
  services.logind.powerKey = "hibernate";

  # Polkit
  users.users.${username}.packages = [ pkgs.lxqt.lxqt-policykit ];

  # Display manager
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "Windows12-Sddm";
    extraPackages = 
    let
      sddm-windows-12 = pkgs.stdenv.mkDerivation rec {
        pname = "sddm-windows-12";
        name = "sddm-windows-12";
        dontBuild = true;
        installPhase = ''
          mkdir -p $out/share/sddm/themes
          cp $src/Windows12-sddm.tar.xz $out/share/sddm/themes/Windows12-sddm.tar.xz
        '';
        src = ./sddm-windows-12;
      };
    in
      [ sddm-windows-12 ];
  };
}
