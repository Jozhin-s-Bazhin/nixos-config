{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.nixos-config.desktop.plasma.enable = lib.mkEnableOption "the KDE Plasma 6 desktop";

  config = lib.mkIf (config.nixos-config.desktop.desktop == "plasma") {
    services = {
      displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };
      desktopManager.plasma6.enable = true;
    };
    programs.kdeconnect.enable = true;
    nixos-config.desktop.theming.enable = false;
    fonts.packages = [ pkgs.nerd-fonts.hack ];
    home-manager.users.${config.nixos-config.username}.home.packages = with pkgs.kdePackages; [
      kcalc
      merkuro
      kcontacts
      plasma-vault
    ];
  };
}
