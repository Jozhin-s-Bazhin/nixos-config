{ config, pkgs, username, configDir, ... }:

{
	home-manager.users.${username} = {
		wayland.windowManager.hyprland.settings.exec-once = [
			# Clipboard
			"${pkgs.wl-clipboard-rs}/bin/wl-paste --type text --watch cliphist store"
			"${pkgs.wl-clipboard-rs}/bin/wl-paste --type image --watch cliphist store"

			# Automount USB drives
			"${pkgs.udiskie}/bin/udiskie"

			# wlsunset
			"${pkgs.writers.writeBash "wlsunset" ''
			  location=$(curl -s ipinfo.io/loc);
				fallback_sunrise="7:00";
				fallback_sunset="18:30";

				if [ $? -eq 0 ] && [ -n "$location" ]; then
					latitude=$(echo $location | cut -d',' -f1);
					longitude=$(echo $location | cut -d',' -f2);
					${pkgs.wlsunset}/bin/wlsunset -l $latitude -L $longitude;
				else
					${pkgs.wlsunset}/bin/wlsunset -S $fallback_sunrise -s $fallback_sunset;
				fi
			''}"
		];
	};
}
