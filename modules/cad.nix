{ inputs, pkgs, username, ...}:
{
  home-manager.users.${username}.home.packages = with pkgs; [ 
    bambu-studio
    inputs.ondsel.packages."x86_64-linux".default
  ];
}
