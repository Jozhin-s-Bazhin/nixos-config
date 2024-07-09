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
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  };

  xdg = { 
    autostart.enable = true; 
    portal = { 
      enable = true; 
      extraPortals = [ pkgs.xdg-desktop-portal pkgs.xdg-desktop-portal-gtk ]; 
    };
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
