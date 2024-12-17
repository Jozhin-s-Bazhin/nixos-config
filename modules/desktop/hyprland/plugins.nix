{ inputs, pkgs, username, ... }:
{
	home-manager.users.${username}.wayland.windowManager.hyprland = {
		plugins = [
			pkgs.hyprlandPlugins.hyprspace
		];

		settings.plugin = {
			overview = {
				dragAlpha = 1;
				panelHeight = 200;
				hideTopLayers = true;
				workspaceActiveBorder = "rgba(00000000)";
				workspaceInactiveBorder = "rgba(00000000)";
				showNewWorkspace = false;
			};
		};
	};
}
