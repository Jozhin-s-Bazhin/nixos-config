{ pkgs, inputs, lib, config, ... }:

{
	imports = [
		./home_manager_config.nix
		./programs.nix
		./hyprland
		./theming.nix
	];
  
  options.nixos-config.desktop.enable = lib.mkEnableOption "a graphical desktop";
  
  config.nixos-config.desktop = lib.mkIf config.nixos-config.desktop.enable {
    programs.enable = lib.mkDefault true;
    theming.enable = lib.mkDefault true;
    hyprland.enable = lib.mkDefault true;
  };
}
