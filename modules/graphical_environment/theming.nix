{ inputs, pkgs, username, configDir, ... }:
{
  imports = [
    inputs.stylix.nixosModules.stylix
    #inputs.stylix.homeManagerModules.stylix
  ];
  
  home-manager.users.${username}.stylix = {
    enable = true;
    image = "${configDir}/modules/graphical_environment/wallpaper/wallpaper.jpg";
    /*cursor = {
      name = "Bibata";
      package = pkgs.bibata-cursors;
      size = 128;
    };
    polarity = "dark";*/
  };
}
