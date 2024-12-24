{ pkgs, config, lib, ... }:

{
  options.nixos-config.desktop.programs.enable = lib.mkEnableOption "programs I want on any system with a graphical desktop";

  config = lib.mkIf config.nixos-config.desktop.programs.enable {
    home-manager.users.${config.nixos-config.username} = {
      home.packages = with pkgs; [
        thunderbird
        bitwarden
        spotube
        obsidian
        zapzap
        inputs.zen.packages."${pkgs.system}".default
      ];
    };
  };
}
