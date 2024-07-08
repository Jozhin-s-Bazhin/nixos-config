{ pkgs, inputs, username, configDir, architecture, ... }:

{
  imports = [
    ./home_manager_config.nix  # Configuration of home-manager itself
    ./programs.nix  # List of packages
    ./appconfig.nix  # A config for all of my apps unrelated to the desktop
    ./desktop/hyprland.nix  # Hyprland and all related things
    ./ags/ags.nix
    #./theming.nix
  ];
}
