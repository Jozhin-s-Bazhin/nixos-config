{ pkgs, inputs, username, ... }:

{
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      networkmanagerapplet
      gnome-calculator
      mission-center
      bitwarden
      whatsapp-for-linux
      thunderbird
      spotube
      pavucontrol   
      obsidian
    ];
  };
}
