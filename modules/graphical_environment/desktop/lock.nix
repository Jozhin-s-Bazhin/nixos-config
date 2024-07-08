{ pkgs, username, architecture, inputs, configDir, ... }:
{
  
  # Hyprlock
  home-manager.users.${username} = {
    programs.hyprlock = {
      enable = true;
      settings = {
        background = [
          {
            monitor = ""; path = "${configDir}/modules/graphical_environment/wallpaper/wallpaper_blurred.png";  # Use a premade blurred image for more speed 
	  }
        ];
        label = [
          # User "icon"
          {
            monitor = "";
            text = "";
            color = "rgba(200, 200, 200, 1)";
            font_size = 32;
            font_family = "Ubuntu Nerd Font";
            position = "-167, 5";
            halign = "center";
            valign = "bottom";
          }
          
          # Battery
          {
            monitor = "";
            text = "cmd[update:120000] ${pkgs.writeShellScript "battery.sh" ''
              percent=$(upower -i $(upower -e | grep 'battery') | grep 'percentage:' | awk '{print $2}' | tr -d '%');
              icon=$(if [[ $percent -le 5 ]]; then 
                echo ""; 
              elif [[ $percent -le 25 ]]; then 
                echo ""; 
              elif [[ $percent -le 60 ]]; then 
                echo "";
              elif [[ $percent -le 85 ]]; then 
                echo ""; 
              else 
                echo ""; 
              fi); 
              echo "$icon"
            ''}";
            color = "rgba(200, 200, 200, 1)";
            font_size = 10;
            font_family = "Ubuntu Nerd Font Med";
            position = "-5, 5";
            halign = "right";
            valign = "top";
          }
          
          # WiFi
          {
            monitor = "";
            text = "cmd[update:10000] ${pkgs.writeShellScript "wifi.sh" ''
              quality=$(iwconfig wlp2s0 | grep -i 'link quality' | awk -F'=' '{print $2}' | awk -F'/' '{print $1}');
              icon=$(if [ -z "$quality" ]; then 
                echo "󰤭"; 
              elif [ "$quality" -lt 10 ]; then 
                echo "󰤯"; 
              elif [ "$quality" -lt 25 ]; then
                echo "󰤟"; 
              elif [ "$quality" -lt 45 ]; then 
                echo "󰤢"; 
              elif [ "$quality" -lt 60 ]; then 
                echo "󰤥"; 
              else 
                echo "󰤨"; 
              fi);
              echo $icon
            ''}";
            color = "rgba(200, 200, 200, 1)";
            font_size = 10;
            font_family = "Ubuntu Nerd Font Med";
            position = "-35, -5";
            halign = "right";
            valign = "top";
          }
          
          # Time
          {
            monitor = "";
            text = "cmd[update:30000] echo \"$(date +%R)\"";  # Not worth the effort of wrapping in a writeShellScript
            color = "rgba(200, 200, 200, 0.8)";
            font_size = 90;
            font_family = "Montserrat";
            position = "0, 150";
            halign = "center";
            valign = "center";
          }
          
          # Date
          {
            monitor = "";
            text = "cmd[update:43200000] echo \"$(date '+%A, %d %B %Y')\"";
            color = "rgba(200, 200, 200, 0.85)";
            font_size = 25;
            font_family = "Montserrat";
            position = "0, 125";
            halign = "center";
            valign = "center";
          }

	  # Ugly gross hack to signal when hyprlock is ready to sleep
	  {
	    monitor = "";
	    text = "cmd[update:1000] echo 'Sleepy time' >&2";  # A script that writes stuff to stderr so it can be read trough a pipe in real time to suspend the device
	    color = "rgba(0, 0, 0, 0)";  # Fully transparent
	    font_size = 1;  	#
	    halign = "center";  # it's invisible so just some random values
	    valign = "center";  #
	    position = "0, 0";  #
	  }
        ];
        input-field = [
          {
            monitor = "";
            size = "275, 40";
            outline_thickness = 0;
            dots_size = 0.33; # Scale of input-field height, 0.2 - 0.8
            dots_spacing = 0.15; # Scale of dots' absolute size, 0.0 - 1.0
            dots_center = true;
            dots_rounding = -1; # -1 default circle, -2 follow input-field rounding
            inner_color = "rgb(200, 200, 200)";
            font_color = "rgb(25, 25, 25)";
            fade_on_empty = false;
            placeholder_text = "<i>Enter password</i>"; # Text rendered in the input box when it's empty.
            hide_input = false;
            rounding = -1; # -1 means complete rounding (circle/oval)
            check_color = "rgb(200, 200, 200)";
            fail_color = "rgb(200, 200, 200)";  # if authentication failed, changes outer_color and fail message color
            fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>"; # can be set to empty
            fail_transition = 300; # transition time in ms between normal outer_color and fail_color
            capslock_color = -1;
            numlock_color = -1;
            bothlock_color = -1; # when both locks are active. -1 means don't change outer color (same for above)
            invert_numlock = false; # change color if numlock is off
            swap_font_color = false; # see below

            position = "0, 10";
            halign = "center";
            valign = "bottom";
          }
        ];
      };
    };
    
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
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
    ];
  };
  
  systemd.services.lockBeforeSleep = {
    enable = false;
    description = "Lock the screen before sleeping";
    before = [ "sleep.target" ];
    wantedBy = [ "sleep.target" ];
    serviceConfig = {
      Type = "notify";
      User = username;
      # Weird stuff happens when i indent this
      ExecStart = "${pkgs.writeScriptBin "findme" ''
#!/run/current-system/sw/bin/bash

# Environment variables that make hyprlock work
export XDG_RUNTIME_DIR="/run/user/$(loginctl list-sessions | ${pkgs.gawk}/bin/awk 'NR==2 {print $2}')"
export WAYLAND_DISPLAY="wayland-$(loginctl list-sessions | ${pkgs.gawk}/bin/awk 'NR==2 {print $1}')"

${pkgs.hyprlock}/bin/hyprlock 2>&1 >/dev/null | while read -r line; do
if [[ $line == "Sleepy time" ]]; then
	systemd-notify --ready
fi
done
      ''}/bin/findme";
      
        /*
        #!/run/current-system/sw/bin/bash

        export XDG_RUNTIME_DIR="/run/user/$(loginctl list-sessions | ${pkgs.gawk}/bin/awk 'NR==2 {print $2}')";
        export WAYLAND_DISPLAY="wayland-$(loginctl list-sessions | ${pkgs.gawk}/bin/awk 'NR==2 {print $1}')";

	${pkgs.procps}/bin/pidof hyprlock 
        ${pkgs.hyprlock}/bin/hyprlock 2>&1 >/dev/null | 
	while read -r line; do
  	  if [[ $line == "Sleepy time" ]]; then 
	    break
	  fi
	done
	*/
    };
  };
}
