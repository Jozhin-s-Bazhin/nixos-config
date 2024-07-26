{ pkgs, inputs, username, configDir, architecture, ... }:

{
  imports = [
    ./home_manager_config.nix
    ./programs.nix
    ./appconfig.nix 
    ./hyprland 
    ./ags
    ./theming.nix
  ];
}