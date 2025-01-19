{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  stylixOptions = {
    enable = true;
    image = ./wallpaper/wallpaper.jpg;
    polarity = "dark";
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
in
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  options = {
    nixos-config.desktop.theming = {
      enable = lib.mkEnableOption "system-wide theme and fonts";
      blurredWallpaper = lib.mkOption { type = with lib.types; coercedTo package toString path; };
    };
  };

  config = lib.mkIf config.nixos-config.desktop.theming.enable {
    nixos-config.desktop.theming.blurredWallpaper = ./wallpaper/wallpaper_blurred.jpg;
    stylix = stylixOptions;
    home-manager.users.${config.nixos-config.username} = {
      stylix = stylixOptions;

      gtk = {
        enable = true;
        iconTheme = {
          package = pkgs.morewaita-icon-theme;
          name = "MoreWaita";
        };
      };
    };
    fonts.packages = [ pkgs.nerd-fonts.symbols-only ];
  };
}
