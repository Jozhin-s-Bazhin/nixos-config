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
        size = 24;
      };
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
	  package = pkgs.ubuntu_font_family;
	  name = "Ubuntu Mono";
	};
        emoji = {
	  package = pkgs.whatsapp-emoji-font;
	  name = "Whatsapp Emoji";
	};
      };
      base16Scheme = {
        system = "base16";
        variant = "dark";
        palette = {
          base00 = "151515";
          base01 = "202020";
          base02 = "303030";
          base03 = "505050";
          base04 = "066cfa";
          base05 = "D0D0D0";
          base06 = "E0E0E0";
          base07 = "F5F5F5";
          base08 = "AC4142";
          base09 = "D28445";
          base0A = "F4BF75";
          base0B = "90A959";
          base0C = "75B5AA";
          base0D = "066CFA";
          base0E = "AA759F";
          base0F = "8F5536";
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
  fonts.packages = [ (pkgs.nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; }) ];
}
