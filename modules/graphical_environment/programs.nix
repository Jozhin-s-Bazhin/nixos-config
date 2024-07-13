{ pkgs, inputs, username, ... }:

{
  home-manager.users.${username}.home.packages = with pkgs; [
    floorp
    qbittorrent
    vlc
    spotube
    whatsapp-for-linux
    libreoffice
    bitwarden
    thunderbird
    pavucontrol
    thunar
    
    # CLI tools
    graphicsmagick
    neofetch 
    fastfetch
    lolcat
    sl
    cmatrix
    pipes-rs
    htop
  ];
}
