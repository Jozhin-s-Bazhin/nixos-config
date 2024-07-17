{ inputs, pkgs, username, configDir, ... }:
{
  imports = [ inputs.stylix.nixosModules.stylix ];
  
  stylix.image = ./wallpaper/wallpaper.jpg;  # It breaks without this
  home-manager.users.${username} = {
    stylix = {
      enable = true;
      image = ./wallpaper/wallpaper.jpg;
      cursor = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
        size = 20;
      };
      base16Scheme = "${pkgs.base16-schemes}/share/themes/google-dark.yaml";
      fonts = {
        serif = {
	  package = pkgs.inter;
	  name = "Inter";
	};
        sansSerif = {
	  package = pkgs.inter;
	  name = "Inter";
	};
	monospace = {
	  package = pkgs.dejavu_fonts;
	  name = "DejaVu Sans Mono";
	};
        emoji = {
	  package = pkgs.whatsapp-emoji-font;
	  name = "Whatsapp Emoji";
	};
      };
    };
    gtk = {
      enable = true;
      iconTheme = {
        package = pkgs.adwaita-icon-theme;
	name = "Adwaita";
      };
    };
  };
  fonts.packages = [ (pkgs.nerdfonts.override { fonts = [ "Symbols Nerd Font Mono" ]; }) ];
}
