{ inputs, pkgs, username, ...}:
{
  home-manager.users.${username}.home.packages = with pkgs; [ 
    bambu-studio

    # Fusion360
    bottles
    wineWowPackages.stable
  ];
}
