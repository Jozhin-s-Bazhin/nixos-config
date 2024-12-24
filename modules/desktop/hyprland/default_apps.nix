{ pkgs, username, ... }:
{
	home-manager.users.${username} = {
		home.packages = with pkgs; [
			gnome-calculator
			mission-center
			nautilus
			eog
		];

		xdg.mimeApps = {
			enable = true;
			defaultApplications = {
				# Nautilus
				"inode/directory" = "org.gnome.Nautilus.desktop";
				
				# Eye of GNOME
				"image/jpg" = "org.gnome.eog.desktop";
				"image/png" = "org.gnome.eog.desktop";
				"image/webp" = "org.gnome.eog.desktop";
			};
		};
    
    # Kitty
		programs.kitty = {
			enable = true;
			settings = {
				confirm_os_window_close = "0";
				window_padding_width = "3";
				font_size = "14";
				enable_audio_bell = "no";
				hide_window_decorations = "yes";
	      linux_display_server = "wayland";
			};
    };
	};
}
