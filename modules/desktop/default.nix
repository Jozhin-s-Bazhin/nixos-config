{
  lib,
  config,
  ...
}:

{
  imports = [
    ./home_manager_config.nix
    ./programs.nix
    ./hyprland
    ./theming.nix
    ./plasma
    ./gnome
    ./cosmic
  ];

  options.nixos-config.desktop.enable = lib.mkEnableOption "a graphical desktop";

  config.nixos-config = lib.mkIf config.nixos-config.desktop.enable {
    desktop = {
      programs.enable = lib.mkDefault true;
      theming.enable = lib.mkDefault true;
      hyprland.enable = lib.mkDefault true;
    };
    pc.enable = true;
  };
}
