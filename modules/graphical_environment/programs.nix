{ pkgs, inputs, username, ... }:

{
  home-manager.users.${username}.home.packages = with pkgs; [
    floorp
    qbittorrent
    vlc
    spotube
    libreoffice
    bitwarden
    thunderbird
    pavucontrol
    nautilus
    whatsapp-for-linux
    
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
