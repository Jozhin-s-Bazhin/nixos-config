{ pkgs, username, lib, ... }:
{
	environment.systemPackages = with pkgs.gnomeExtensions; [
		blur-my-shell
		forge
		gsconnect
		dash-to-panel
		switch-workspaces-on-active-monitor
		open-browser-tabs-on-active-workspace
	];

	home-manager.users.${username}.dconf.settings = {
		"org/gnome/shell" = {
			disable-user-extensions = false;
			enabled-extensions = with pkgs.gnomeExtensions; [
				blur-my-shell.extensionUuid
				forge.extensionUuid
				gsconnect.extensionUuid
				dash-to-panel.extensionUuid
				switch-workspaces-on-active-monitor.extensionUuid
				open-browser-tabs-on-active-workspace.extensionUuid
			];
		};
		"/org/gnome/shell/extensions/dash-to-panel/panel-lengths" = {
			"0"= 100;
			"1" = 100;
		};

		"/org/gnome/shell/extensions/dash-to-panel/panel-sizes" = {"0" = 32; "1" = 32;};
		"/org/gnome/shell/extensions/dash-to-panel/panel-element-positions" = lib.gvariant.mkValue [
	(lib.gvariant.mkDictionaryEntry "0" [
		(lib.gvariant.mkDictionaryEntry "element" "showAppsButton")
		(lib.gvariant.mkDictionaryEntry "visible" false)
		(lib.gvariant.mkDictionaryEntry "position" "stackedBR")

		(lib.gvariant.mkDictionaryEntry "element" "activitiesButton")
		(lib.gvariant.mkDictionaryEntry "visible" true)
		(lib.gvariant.mkDictionaryEntry "position" "stackedTL")

		(lib.gvariant.mkDictionaryEntry "element" "leftBox")
		(lib.gvariant.mkDictionaryEntry "visible" true)
		(lib.gvariant.mkDictionaryEntry "position" "stackedBR")

		(lib.gvariant.mkDictionaryEntry "element" "taskbar")
		(lib.gvariant.mkDictionaryEntry "visible" false)
		(lib.gvariant.mkDictionaryEntry "position" "centerMonitor")

		(lib.gvariant.mkDictionaryEntry "element" "centerBox")
		(lib.gvariant.mkDictionaryEntry "visible" true)
		(lib.gvariant.mkDictionaryEntry "position" "stackedBR")

		(lib.gvariant.mkDictionaryEntry "element" "rightBox")
		(lib.gvariant.mkDictionaryEntry "visible" false)
		(lib.gvariant.mkDictionaryEntry "position" "stackedBR")

		(lib.gvariant.mkDictionaryEntry "element" "dateMenu")
		(lib.gvariant.mkDictionaryEntry "visible" true)
		(lib.gvariant.mkDictionaryEntry "position" "centered")

		(lib.gvariant.mkDictionaryEntry "element" "systemMenu")
		(lib.gvariant.mkDictionaryEntry "visible" true)
		(lib.gvariant.mkDictionaryEntry "position" "stackedBR")

		(lib.gvariant.mkDictionaryEntry "element" "desktopButton")
		(lib.gvariant.mkDictionaryEntry "visible" false)
		(lib.gvariant.mkDictionaryEntry "position" "stackedBR")
	])

	(lib.gvariant.mkDictionaryEntry "1" [
		(lib.gvariant.mkDictionaryEntry "element" "showAppsButton")
		(lib.gvariant.mkDictionaryEntry "visible" false)
		(lib.gvariant.mkDictionaryEntry "position" "stackedBR")

		(lib.gvariant.mkDictionaryEntry "element" "activitiesButton")
		(lib.gvariant.mkDictionaryEntry "visible" true)
		(lib.gvariant.mkDictionaryEntry "position" "stackedTL")

		(lib.gvariant.mkDictionaryEntry "element" "leftBox")
		(lib.gvariant.mkDictionaryEntry "visible" true)
		(lib.gvariant.mkDictionaryEntry "position" "stackedBR")

		(lib.gvariant.mkDictionaryEntry "element" "taskbar")
		(lib.gvariant.mkDictionaryEntry "visible" false)
		(lib.gvariant.mkDictionaryEntry "position" "centerMonitor")

		(lib.gvariant.mkDictionaryEntry "element" "centerBox")
		(lib.gvariant.mkDictionaryEntry "visible" true)
		(lib.gvariant.mkDictionaryEntry "position" "stackedBR")

		(lib.gvariant.mkDictionaryEntry "element" "rightBox")
		(lib.gvariant.mkDictionaryEntry "visible" false)
		(lib.gvariant.mkDictionaryEntry "position" "stackedBR")

		(lib.gvariant.mkDictionaryEntry "element" "dateMenu")
		(lib.gvariant.mkDictionaryEntry "visible" true)
		(lib.gvariant.mkDictionaryEntry "position" "centered")

		(lib.gvariant.mkDictionaryEntry "element" "systemMenu")
		(lib.gvariant.mkDictionaryEntry "visible" true)
		(lib.gvariant.mkDictionaryEntry "position" "stackedBR")

		(lib.gvariant.mkDictionaryEntry "element" "desktopButton")
		(lib.gvariant.mkDictionaryEntry "visible" false)
		(lib.gvariant.mkDictionaryEntry "position" "stackedBR")
	])
];

		"/org/gnome/shell/extensions/dash-to-panel/panel-positions" = {
			"0" = "TOP";
			"1" = "TOP";
		};
	};
}
