{ pkgs, inputs, username, ... }:

{
  home-manager.users.${username}.home.packages = with pkgs; [
    spotube
    pavucontrol
    nautilus
    bitwarden
    whatsapp-for-linux
    thunderbird
    
    # CLI stuff
    graphicsmagick
    neofetch 
    fastfetch
    lolcat
    sl
    cmatrix
    pipes-rs
  ];
}
