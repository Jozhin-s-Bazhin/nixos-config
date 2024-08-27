{ config, pkgs, username, configDir, ... }:

{
  home-manager.users.${username} = {
    wayland.windowManager.hyprland.settings.exec-once = [
      # Clipboard
      "wl-paste --type text --watch cliphist store"
      "wl-paste --type image --watch cliphist store"

      # Automount USB drives
      "udiskie"
    ];

    home.packages = with pkgs; [
      cliphist
      wl-clipboard-rs
      udiskie
    ];
  };
}
