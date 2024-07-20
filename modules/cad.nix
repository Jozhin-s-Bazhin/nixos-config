{ inputs, pkgs, username, ...}:
{
  imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];
  services.flatpak.enable = true;

  home-manager.users.${username}.home.packages = with pkgs; [ 
    freecad
    bambu-studio
  ];
}
