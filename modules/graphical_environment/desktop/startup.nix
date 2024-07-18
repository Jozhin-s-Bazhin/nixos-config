{ config, pkgs, username, configDir, ... }:

{
  home-manager.users.${username} = {
    wayland.windowManager.hyprland.settings = {
      exec-once = [
        # Polkit
        "lxqt-policykit-agent"

        # Clipboard manager
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"

        # Other
        "ags"
        "pypr"
        "wluma"

	# Floorp
	#"exec-once = [workspace special:floorp silent] kitty"
      ];
    };

    xdg.configFile."hypr/pyprland.toml".text = ''
      [pyprland]
      plugins = [
        "external:better_workspaces",
        "external:ags_tools"
      ]
      plugins_paths = [
        "${configDir}/modules/graphical_environment/desktop/pypr"
      ]
    '';

    xdg.configFile."wluma/config.toml".text = ''
      [als.iio]
      path = "/sys/bus/iio/devices"
      thresholds = { 0 = "night", 20 = "dark", 80 = "dim", 250 = "normal", 500 = "bright", 800 = "outdoors" }

[[output.backlight]]
name = "eDP-2"
path = "/sys/class/backlight/amdgpu_bl2"
capturer = "wlroots"

#[[keyboard]]
#name = "keyboard-dell"
#path = "/sys/bus/platform/devices/dell-laptop/leds/framework_laptop::kbd_backlight"
    '';

    home.packages = with pkgs; [
      pyprland
      wluma
      cliphist
      wl-clipboard-rs
      hyprpaper
    ];
  };
}
