{
  lib,
  ...
}:

{
  imports = [
    ./hyprland_config.nix
    ./startup.nix
    ./appearance.nix
    ./input.nix
    ./keybinds.nix
    ./default_apps.nix
    ./plugins.nix
    ./lock.nix
    ./other.nix
    ./ags
  ];
}
