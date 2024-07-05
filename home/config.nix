# Here lives shit I don't understand
{ pkgs, config, ... }:
{
  # Enable XDG desktop portal
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "gtk";
  };

  xdg.configFile."wluma/config.toml".text = ''
  [als.iio]
  path = "/sys/bus/iio/devices"
  thresholds = { 0 = "night", 20 = "dark", 80 = "dim", 250 = "normal", 500 = "bright", 800 = "outdoors" }

  [[output.backlight]]
  name = "eDP-2"
  path = "/sys/class/backlight/amdgpu_bl2"
  capturer = "none"
  '';
}
