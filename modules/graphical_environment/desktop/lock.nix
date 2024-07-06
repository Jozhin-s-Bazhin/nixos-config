{ pkgs, username, architecture, inputs, configDir, ... }:
{
  
  # Hyprlock
  home-manager.users.${username} = {
    programs.hyprlock = {
      enable = true;
      package = inputs.hyprlock.packages.${architecture}.hyprlock;
      settings = {
        background = [
          {
            monitor = "";
            path = "${configDir}/modules/graphical_environment/desktop/wallpaper_blurred.png";  # Use a premade blurred image for more speed
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
            text = "cmd[update:30000] echo '$(date +\"%R\")'";  # Not worth the effort of wrapping in a writeShellScript
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
            text = "cmd[update:43200000] echo '$(date +\"%A, %d %B %Y\")'";
            color = "rgba(200, 200, 200, 0.85)";
            font_size = 25;
            font_family = "Montserrat";
            position = "0, 125";
            halign = "center";
            valign = "center";
          }
        ];
        input_field = [
          {
            monitor = "";
            size = "275, 40";
            outline_thickness = 0;
            
            dots_size = 0.33; # Scale of input-field height, 0.2 - 0.8
            dots_spacing = 0.15; # Scale of dots' absolute size, 0.0 - 1.0
            dots_center = false;
            dots_rounding = -1; # -1 default circle, -2 follow input-field rounding

            outer_color = "rgb(200, 200, 200)";
            inner_color = "rgb(200, 200, 200)";
            font_color = "rgb(21, 21, 21)";
            check_color = "rgb(200, 200, 200)";
            fail_color = "rgb(100, 100, 100)";
            rounding = -1; # -1 means complete rounding (circle/oval)

            fail_text = "<i> Incorrect password </i>";
            placeholder_text = "<i></i>";
            fade_on_empty = false;
            hide_input = false;

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
          before_sleep_cmd = "loginctl lock-session";
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
      brightnessctl
      wirelesstools
      montserrat
      nerdfonts
    ];
  };
}