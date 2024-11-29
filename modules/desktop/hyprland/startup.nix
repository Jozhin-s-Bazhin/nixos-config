{ config, pkgs, username, configDir, ... }:

{
  home-manager.users.${username} = {
    wayland.windowManager.hyprland.settings.exec-once = [
      # Clipboard
      "${pkgs.wl-clipboard-rs}/bin/wl-paste --type text --watch cliphist store"
      "${pkgs.wl-clipboard-rs}/bin/wl-paste --type image --watch cliphist store"

      # Automount USB drives
      "${pkgs.udiskie}/bin/udiskie"

      # Wluma
      "${pkgs.wluma}/bin/wluma"
    ];

    xdg.configFile."wluma/config.toml".text = ''
      [als.iio]
      path = "/sys/bus/iio/devices"
      thresholds = { 0 = "night", 20 = "dark", 80 = "dim", 250 = "normal", 500 = "bright", 800 = "outdoors" }

      [[output.backlight]]
      name = "eDP-2"
      path = "/sys/class/backlight/amdgpu_bl2"
      capturer = "wayland"

      [[keyboard]]
      name = "keyboard-framework"
      path = "/sys/bus/platform/devices/framework_laptop/leds/framework_laptop::kbd_backlight"
    '';
  };
}
