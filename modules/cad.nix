{ inputs, pkgs, username, ...}:
{
  home-manager.users.${username}.home.packages = with pkgs; [ 
    freecad
    bambu-studio
    openscad
  ];
}
