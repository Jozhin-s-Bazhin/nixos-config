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
