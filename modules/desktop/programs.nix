{ pkgs, inputs, username, ... }:

{
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      networkmanagerapplet
      gnome-calculator
      mission-center
      thunderbird
      pavucontrol   
      bitwarden
      whatsapp-for-linux
      spotube
      obsidian
      alpaca
    ];
  };
}
