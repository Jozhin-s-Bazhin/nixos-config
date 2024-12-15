{ inputs, pkgs, configDir, architecture, config, ... }:

{
	imports = [
		# Stuff that makes Hyprland work at all
		./hyprland_config.nix

		# Startup commands
		./startup.nix

		# Appearance
		./appearance.nix

		# Input
		./input.nix

		# Keybindings
		./keybinds.nix

		# Default apps
		./default_apps.nix

		# Plugins
		./plugins.nix
		
		# Login, screenlock, polkit, timeout, ...
		./lock.nix

		# Other (monitors and rules)
		./other.nix

		# AGS
		./ags
	];
}
