{ pkgs, username, ...}:
{
  home-manager.users.${username}.home.packages = with pkgs; [ 
    (freecad.override {python = pkgs.python311;})
  ];
}