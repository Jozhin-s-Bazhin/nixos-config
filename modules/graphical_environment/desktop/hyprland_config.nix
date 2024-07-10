{ inputs, pkgs, username, ... }:

{
  imports = [
    inputs.hyprland.nixosModules.default
  ];

  programs.dconf.enable = true;
  home-manager.users.${username} = {
    dconf.enable = true;
    gtk.enable = true;

    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages."${pkgs.system}".hyprland; 
      xwayland.enable = true;
    };
    
    home.packages = with pkgs; [
      nerdfonts
    ];
  };
  
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };

  xdg = { 
    autostart.enable = true; 
    portal = { 
      enable = true; 
      wlr.enable = false;
      xdgOpenUsePortal = false;
      extraPortals = [ 
        pkgs.xdg-desktop-portal-hyprland 
	pkgs.xdg-desktop-portal-gtk 
      ]; 
    };
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

  users.users.${username}.packages = [ pkgs.lxqt.lxqt-policykit ];
}
