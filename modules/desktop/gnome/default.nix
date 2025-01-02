{ config, lib, ... }:
{
	options.nixos-config.desktop.gnome.enable = lib.mkEnableOption "the GNOME desktop";

	config = lib.mkIf config.nixos-config.desktop.gnome.enable {
		services.xserver = {
			enable = true;
			displayManager.gdm.enable = true;
			desktopManager.gnome.enable = true;
		};
		programs.dconf.enable = true;
	};
}
