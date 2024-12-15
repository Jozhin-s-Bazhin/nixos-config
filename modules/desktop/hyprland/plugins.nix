{ inputs, username, ... }:
{
	home-manager.users.${username}.wayland.windowManager.hyprland = {
		plugins = [
		];

		settings.plugin = {};
	};
}
