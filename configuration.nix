# _   _   _____  _     _    ____      ___
# | \ | | |_   _| \ \ / /   / __ \   / ___|
# |  \| |   | |    \ V /   | |  | | | (_
# | . ` |   | |     > <    | |  | |  \_  \
# | |\  |  _| |_   / . \   | |__| |  __)  |
# |_| \_| |_____| /_/ \_\   \____/  |____/

# By Roman Bezroutchko


{ inputs, pkgs, config, lib, ... }:

{
  imports =
    [
      inputs.hyprland.nixosModules.default
      ./hardware-configuration.nix 
      ./cli_config.nix
    ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.roman.packages = with pkgs; [ lxqt.lxqt-policykit ]; 

  # Logind
  services.logind = {
    #lidSwitch = "suspend";
    lidSwitch = "ignore";
    powerKey = "hibernate";
  };

  # Hyprland
  programs.hyprland.portalPackage = pkgs.xdg-desktop-portal-hyprland;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  xdg.portal = { enable = true; extraPortals = [ pkgs.xdg-desktop-portal-gtk ]; };

  /*# Greetd
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "Hyprland --config /etc/greetd/hyprland.conf";
        user = "roman";
      };
    };
  };
  environment.etc."greetd/hyprland.conf".source = ./home/package_config/ags/hyprland.conf;
  environment.etc."greetd/greeter.js".source = ./home/package_config/ags/greeter.js;*/

  # Better battery life
  services.upower.enable = true;
}
