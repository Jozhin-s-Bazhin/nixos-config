{ inputs, pkgs, config, lib, ... }:
let
	opacity = 0.8;
in
{
	imports = [ inputs.stylix.nixosModules.stylix ];
	
  options = {
		nixos-config.desktop.theming.enable = lib.mkEnableOption "system-wide theme and fonts";
		stylix.blurredImage = lib.mkOption {
      type = with lib.types; coercedTo package toString path;
      description = ''
        Blurred wallpaper image.

        This is set as the background of your screenlocker and display manager.
      '';
    };
	};

  config = lib.mkIf config.nixos-config.desktop.theming.enable {
    stylix.image = ./wallpaper/wallpaper.jpg;	# It breaks without this
		stylix.blurredImage = ./wallpaper/wallpaper_blurred.jpg;  # This is a custom option not really related to stylix
    home-manager.users.${config.nixos-config.username} = {
      stylix = {
        enable = true;
        image = ./wallpaper/wallpaper.jpg;
        opacity = {
          terminal = opacity;
          desktop = opacity;
          popups = opacity;
          applications = opacity;
        };
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

			qt = {
				enable = true;
				platformTheme.name = "adwaita";
				style.name = "adwaita-dark";
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
  };
}
