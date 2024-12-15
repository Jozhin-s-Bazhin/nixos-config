{ pkgs, username, architecture, inputs, configDir, config, lib, ... }:
{
	security.pam.services.gtklock.text = lib.readFile "${pkgs.gtklock}/etc/pam.d/gtklock";

	home-manager.users.${username} = {
		services.hypridle = {
			enable = true;
			settings = { 
				general.lock_cmd = "gtklock";
				listener = [
					{
						timeout = 840;
						on-timeout = "brightnessctl -s set 1";
						on-resume = "brightnessctl -r";
					}
					{
						timeout = 900;
						on-timeout = "systemctl suspend-then-hibernate";
					}
				];
			};
		};
		
		xdg.configFile."gtklock/config.ini".text = ''
			[main]
			style=/home/${username}/.config/gtklock/style.css
		'';
		xdg.configFile."gtklock/style.css".text = ''
			window {
				background-image: url("${configDir}/modules/desktop/wallpaper/wallpaper_blurred.png");
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
			User = username;
			ExecStart = "${pkgs.writeScriptBin "lockBeforeSleep" ''
#!/run/current-system/sw/bin/bash -l

# Environment variables
loginctl_sessions=$(loginctl list-sessions)
export XDG_RUNTIME_DIR="/run/user/$(echo "$loginctl_sessions" | ${pkgs.gawk}/bin/awk 'NR==2 {print $2}')"
export DBUS_SESSION_ADDRESS="unix:path=/run/user/$(echo "$loginctl_sessions" | ${pkgs.gawk}/bin/awk 'NR==2 {print $2}')/bus"

${pkgs.gtklock}/bin/gtklock -L "systemd-notify --ready" --display "wayland-1"
			''}/bin/lockBeforeSleep";
		};
	};

	# Map power key to hibernate instead of shutdown
	services.logind = {
		powerKey = "hibernate";
		lidSwitch = "suspend-then-hibernate";
	};
	systemd.sleep.extraConfig = "HibernateDelaySec=3h";

	# Polkit
	users.users.${username}.packages = [ pkgs.lxqt.lxqt-policykit ];
}
