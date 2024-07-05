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
  };
  
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  };
}