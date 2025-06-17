{ config, lib, ... }:
{
  config = lib.mkIf (config.nixos-config.desktop.desktop == "gnome") {
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
    programs.dconf.enable = true;
  };
}
