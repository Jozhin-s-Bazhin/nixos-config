{ pkgs, inputs, username, ... }:

{
  home-manager.users.${username} = {
    home.packages = with pkgs; [
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
