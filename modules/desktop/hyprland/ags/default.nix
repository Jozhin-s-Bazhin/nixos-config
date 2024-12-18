{ inputs, lib, pkgs, username, configDir, ... }:

{
	services.upower.enable = true;
	home-manager.users.${username} = {
		imports = [ 
			inputs.ags.homeManagerModules.default 
		];

		programs.ags = {
			enable = true;
			extraPackages = with pkgs; [
				gtksourceview
				webkitgtk
				accountsservice
				libnotify
				nerd-fonts.symbols-only
				gnome-bluetooth
				brightnessctl
				networkmanagerapplet
				bash
				killall
				wluma
			];
		};

		wayland.windowManager.hyprland.settings.exec-once = [ "${inputs.ags.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/ags -c ${configDir}/modules/desktop/hyprland/ags/config.js" ];
	};
}
