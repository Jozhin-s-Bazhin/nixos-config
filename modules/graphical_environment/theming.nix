{ inputs, pkgs, username, configDir, ... }:
{
  imports = [ inputs.stylix.nixosModules.stylix ];
  
  # This doesn't work properly. 
  stylix = {
    enable = true;
    image = ./wallpaper/wallpaper.jpg;
    cursor = {
      name = "Adwaita";
      package = pkgs.adwaita-cursor-theme;
      size = 24;
    };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/classic-dark.yaml";
  };
  home-manager.users.${username}.stylix = {
    enable = true;
    image = ./wallpaper/wallpaper.jpg;
    cursor = {
      name = "Adwaita";
      package = pkgs.adwaita-cursor-theme;
      size = 24;
    };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/classic-dark.yaml";
  };
}
