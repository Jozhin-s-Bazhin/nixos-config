{ inputs, pkgs, username, configDir, ... }:
{
  imports = [ inputs.stylix.nixosModules.stylix ];
  
  #stylix.enable = true;
  #stylix.image = "${configDir}/modules/graphical_environment/wallpaper/wallpaper.png";
  home-manager.users.${username}.stylix = {
    enable = true;
    image = "./wallpaper/wallpaper.png";
    cursor = {
      name = "Bibata";
      package = pkgs.bibata-cursors;
      size = 128;
    };
    polarity = "dark";
  };
}
