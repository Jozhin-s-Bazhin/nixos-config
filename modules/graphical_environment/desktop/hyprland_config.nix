{ inputs, pkgs, username, ... }:

{
  imports = [
    inputs.hyprland.nixosModules.default
    inputs.hyprland.homeManagerModules.default
  ];

  programs.dconf.enable = true;

  home-manager.users.${username} = {
    dconf.enable = true;
    gtk.enable = true;

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    
    home.packages = with pkgs; [
      nerdfonts
    ];
  };
  
  programs.hyprland.enable = true;

  xdg.portal.extraPortals = [ 
	pkgs.xdg-desktop-portal-gtk 
      ]; 

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XDG_SESSION_TYPE = "wayland";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    QT_QPA_PLATFORM = "wayland;xcb";
  };
}
