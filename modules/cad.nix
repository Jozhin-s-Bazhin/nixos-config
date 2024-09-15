{ inputs, pkgs, username, ...}:
{
  home-manager.users.${username}.home.packages = with pkgs; [ 
    freecad-wayland
    openscad
    orca-slicer
  ];
}
