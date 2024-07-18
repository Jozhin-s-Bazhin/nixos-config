{ pkgs, inputs, username, ... }:

{
  home-manager.users.${username}.home.packages = with pkgs; [
    floorp
    spotube
    pavucontrol
    nautilus
    bitwarden
    thunderbird
    whatsapp-for-linux
    gpt4all
    
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
