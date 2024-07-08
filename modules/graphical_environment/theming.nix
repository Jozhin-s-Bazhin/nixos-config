{ inputs, pkgs, username, configDir, ... }:
{
  imports = [
    inputs.stylix.nixosModules.stylix
    #inputs.stylix.homeManagerModules.stylix
  ];
  
  home-manager.users.${username}.stylix = {
    image = "${configDir}/modules/graphical_environment/wallpaper/wallpaper.jpg";
    enable = true;
    /*cursor = {
      name = "Bibata";
      package = pkgs.bibata-cursors;
      size = 128;
    };
    polarity = "dark";*/
  };
}
