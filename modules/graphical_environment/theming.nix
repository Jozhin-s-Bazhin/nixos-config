{ inputs, pkgs, username, configDir, ... }:
{
  imports = [ inputs.stylix.nixosModules.stylix ];
  
  stylix.image = ./wallpaper/wallpaper.jpg;  # It breaks without this
  home-manager.users.${username} = {
    stylix = {
      enable = true;
      image = ./wallpaper/wallpaper.jpg;
      cursor = {
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
        size = 24;
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
	  package = pkgs.nerdfonts.override { fonts = [ "DejaVuSansMono" ]; };
	  name = "DejaVu Sans Mono Nerd Font";
	};
        emoji = {
	  package = pkgs.whatsapp-emoji-font;
	  name = "Whatsapp Emoji";
	};
      };
    };
  };
}
