{ inputs, pkgs, username, configDir, ... }:
{
  imports = [
    #stylix.nixosModules.stylix
    inputs.stylix.homeManagerModules.stylix
  ];
  
  home-manager.users.${username}.stylix = {
    enable = true;
    cursor = {
      name = "Bibata";
      package = pkgs.bibata-cursors;
      size = 128;
    };
    image = "${configDir}/modules/graphical_environment/wallpaper/wallpaper.jpg";
    polarity = "dark";
  };
}
