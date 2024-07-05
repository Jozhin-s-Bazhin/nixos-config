{ inputs, pkgs, username, ... }:
{
  imports = [
    ./hyprland.nix
    ./ags/ags.nix
  ];
}