{ inputs, pkgs, username, configDir, ... }:
{
  imports = [ inputs.stylix.nixosModules.stylix ];
  
  home-manager.users.${username}.stylix = {
    enable = true;
    image = /home/roman/nixos-config/modules/graphical_environment/wallpaper/wallpaper.png;
    /*cursor = {
      name = "Bibata";
      package = pkgs.bibata-cursors;
      size = 128;
    };
    polarity = "dark";*/
  };
}
