{ inputs, pkgs, config, lib, ... }:

{
  config = lib.mkIf config.nixos-config.desktop.hyprland.enable {
    nix.settings = {
      substituters	= [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
    programs.dconf.enable = true;

    home-manager.users.${config.nixos-config.username} = {
      dconf.enable = true;
      gtk.enable = true;

      wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;
        systemd.enable = false;
      };
    };
    
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      XDG_SESSION_TYPE = "wayland";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      QT_QPA_PLATFORM = "wayland;xcb";
    };

    xdg = { 
      autostart.enable = true; 
      portal = { 
        enable = true; 
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ]; 
      }; 
    };
    services.dbus.enable = true;
  };
}
