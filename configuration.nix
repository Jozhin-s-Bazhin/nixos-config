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

  # Hyprland
  programs.hyprland.portalPackage = pkgs.xdg-desktop-portal-hyprland;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  xdg.portal = { enable = true; extraPortals = [ pkgs.xdg-desktop-portal-gtk ]; };
}
