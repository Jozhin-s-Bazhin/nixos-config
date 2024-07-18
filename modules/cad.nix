{ pkgs, username, ...}:
{
  nixpkgs.overlays = [
    (final: prev: {
      freecad = prev.freecad.overrideAttrs (oldAttrs: {
        # Override shiboken2 to use Python 3.11
        shiboken2 = final.python311Packages.shiboken2;
      });
    })
  ];

  home-manager.users.${username}.home.packages = with pkgs; [ freecad ];
}
