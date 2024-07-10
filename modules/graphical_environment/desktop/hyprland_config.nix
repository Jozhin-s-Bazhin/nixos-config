{ inputs, pkgs, username, ... }:

{
  programs.dconf.enable = true;

  home-manager.users.${username} = {
    dconf.enable = true;
    gtk.enable = true;

    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    };
    
    home.packages = with pkgs; [
      nerdfonts
    ];
  };
  
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
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
      extraPortals = [ 
        pkgs.xdg-desktop-portal 
	pkgs.xdg-desktop-portal-gtk
      ]; 
    }; 
  };
}
