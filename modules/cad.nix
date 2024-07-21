{ inputs, pkgs, username, ...}:
{
  home-manager.users.${username}.home.packages = with pkgs; [ 
    bambu-studio

    # Fusion 360
    bottles
    wineWowPackages.waylandFull
    wineWow64Packages.waylandFull
  ];
}
