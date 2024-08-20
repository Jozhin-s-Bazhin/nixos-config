{ inputs, pkgs, username, ...}:
{
  home-manager.users.${username}.home.packages = with pkgs; [ 
    freecad
    openscad
    orca-slicer
  ];
}
