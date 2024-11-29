{ config, pkgs, username, configDir, ... }:

{
  home-manager.users.${username} = {
    wayland.windowManager.hyprland.settings.exec-once = [
      # Clipboard
      "${pkgs.wl-clipboard-rs}/bin/wl-paste --type text --watch cliphist store"
      "${pkgs.wl-clipboard-rs}/bin/wl-paste --type image --watch cliphist store"

      # Automount USB drives
      "${pkgs.udiskie}/bin/udiskie"
    ];
  };
}
