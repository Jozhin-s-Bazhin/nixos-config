{ pkgs, username, configDir, ... }:
{
	services.greetd = {
		enable = true;
		settings.default_session = {
			command = "${pkgs.hyprland}/bin/Hyprland --config /etc/greetd/hyprland.conf";
			user = username;
		};
	};
	environment.etc."greetd/hyprland.conf".text = ''
		exec-once = ags --config ${configDir}/modules/desktop/hyprland/ags/greetd/greeter.js; hyprctl dispatch exit
		misc {
			disable_hyprland_logo = true
		}
	'';
}
