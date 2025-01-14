{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
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
    stylix = {
      enable = true;
      image = ./wallpaper/wallpaper.jpg; # It breaks without this
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
      base16Scheme = "${pkgs.base16-schemes}/share/themes/google-dark.yaml";
    };
    stylix.blurredImage = ./wallpaper/wallpaper_blurred.jpg; # This is a custom option not really related to stylix
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
            name = "Ubuntu Mono";
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
    fonts.packages = [
      pkgs.nerd-fonts.symbols-only
      config.home-manager.users.${config.nixos-config.username}.stylix.fonts.serif.package
      config.home-manager.users.${config.nixos-config.username}.stylix.fonts.sansSerif.package
      config.home-manager.users.${config.nixos-config.username}.stylix.fonts.monospace.package
    ];
  };
}
