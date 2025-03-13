{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:

{
  options.nixos-config.desktop.programs.enable =
    lib.mkEnableOption "programs I want on any system with a graphical desktop";

  config = lib.mkIf config.nixos-config.desktop.programs.enable {
    home-manager.users.${config.nixos-config.username} = {
      home.packages = with pkgs; [
        bitwarden
        spotube
        obsidian
        zapzap
        gnome-clocks
        inputs.zen.packages."${pkgs.system}".default
        telegram-desktop
        thunderbird
        baobab
      ];
    };
  };
}
