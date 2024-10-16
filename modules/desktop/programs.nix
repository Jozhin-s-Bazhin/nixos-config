{ pkgs, inputs, username, ... }:

{
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      thunderbird
      pavucontrol   
      bitwarden
      whatsie
      spotube
      obsidian
      alpaca
    ];
  };
}
