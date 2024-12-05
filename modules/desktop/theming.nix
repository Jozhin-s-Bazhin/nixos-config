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
          name = "UbuntuMono";
        };
        emoji = {
          package = pkgs.whatsapp-emoji-font;
          name = "Whatsapp Emoji";
	      };
      };
      base16Scheme = "${pkgs.base16-schemes}/share/themes/google-dark.yaml";
    };

    gtk = {
      enable = true;
      iconTheme = {
        package = pkgs.morewaita-icon-theme;
	name = "MoreWaita";
      };
    };
  };
  fonts.packages = [ pkgs.nerd-fonts.symbols-only ];

  # Boot splash screen
  boot = {
    plymouth.enable = true;
    initrd.verbose = true;
    consoleLogLevel = 0;
    kernelParams = [ "quiet" "splash" ];
  };
}
