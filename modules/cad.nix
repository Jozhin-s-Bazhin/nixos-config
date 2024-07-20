{ pkgs, username, ...}:
{
  imports = [ nix-snapd.nixosModules.default ];
  services.snap.enable = true;
  home-manager.users.${username}.home.packages = with pkgs; [ 
    freecad
    bambu-studio
  ];
}
