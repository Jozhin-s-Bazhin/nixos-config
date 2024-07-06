# Here lives shit I don't understand
{ pkgs, config, ... }:
{
  # Enable XDG desktop portal
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "gtk";
  };

}
