{ pkgs, username, ...}:
{
  nixpkgs.overlays = [
    (final: prev: {
      freecad = prev.freecad.overrideAttrs (oldAttrs: {
        shiboken2 = final.python311Packages.shiboken2;
      });
    })
  ];

  home-manager.users.${username}.home.packages = with pkgs; [ freecad ];
}
