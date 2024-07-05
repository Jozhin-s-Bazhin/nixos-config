{ config, pkgs, username, ... }:

{
  home-manager.users.${username} = {
    wayland.windowManager.hyprland.settings = {
      env = [
        "XCURSOR_SIZE, 24"
        "QT_QPA_PLATFORMTHEME, qt5ct" ];

      exec-once = [
        # Polkit
        "lxqt-policykit-agent"

        # Clipboard manager
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"

        # Other
        "hyprpaper"
        "hypridle"
        "ags"
        "pypr"
        "wluma"
      ];
    };

    xdg.configFile."hypr/hypridle.conf".source = ./hypridle.conf;
  };
}
