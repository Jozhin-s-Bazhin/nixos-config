{ config, pkgs, username, configDir, ... }:

{
  home-manager.users.${username} = {
    wayland.windowManager.hyprland.settings = {
      exec-once = [
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"

	# Start brave in background
	"brave --no-startup-window"
      ];
    };

    home.packages = with pkgs; [
      cliphist
      wl-clipboard-rs
    ];
  };
}
