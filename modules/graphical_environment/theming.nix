{ inputs, pkgs, username, configDir, ... }:
{
  imports = [ inputs.stylix.nixosModules.stylix ];
  
  stylix = {
    enable = true;
    image = ./wallpaper/wallpaper.png;
    cursor = {
      name = "Bibata";
      package = pkgs.bibata-cursors;
      size = 128;
    };
  };
  home-manager.users.${username}.stylix = {
    enable = true;
    #image = "./wallpaper/wallpaper.png";

    polarity = "dark";
  };
}
