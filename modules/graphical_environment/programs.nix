{ pkgs, inputs, username, ... }:

{
  home-manager.users.${username}.home.packages = with pkgs; [
    nautilus
    bitwarden
    whatsapp-for-linux
    thunderbird
    spotube
    pavucontrol   
  ];
}
