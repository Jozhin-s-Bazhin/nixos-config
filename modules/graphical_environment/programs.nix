{ pkgs, inputs, username, ... }:

{
  home-manager.users.${username}.home.packages = with pkgs; [
    floorp
    qbittorrent
    vlc
    spotube
    whatsapp-for-linux
    webcord
    libreoffice
    bitwarden
    thunderbird
    pavucontrol
    
    # CLI tools
    neofetch 
    fastfetch
    lolcat
    sl
    cmatrix
    pipes-rs
    graphicsmagick
  ];
}