{ pkgs, inputs, username, ... }:

{
  imports = [
    ./home_manager_config.nix  # Configuration of home-manager itself
    ./programs.nix  # List of packages
    ./appconfig.nix  # A config for all of my apps unrelated to the desktop
    ./desktop/desktop.nix  # Hyprland and all related things
  ];
}