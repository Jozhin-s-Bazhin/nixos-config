{ pkgs, inputs, username, ... }:
{
  imports = [
    # Stuff that makes other stuff work
    ./gnome_config.nix

    # General GNOME settings
    ./settings.nix

    # Extensions
    ./extensions.nix
  ];
}
