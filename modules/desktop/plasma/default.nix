{ config, lib, ... }:
{
	options.nixos-config.desktop.plasma.enable = lib.mkEnableOption "the KDE Plasma 6 desktop";

	config = lib.mkIf config.nixos-config.desktop.plasma.enable {
		services = {
			displayManager.sddm = {
				enable = true;
				wayland.enable = true;
			};
			desktopManager.plasma6.enable = true;
		};
		programs.kdeconnect.enable = true;
	};
}
