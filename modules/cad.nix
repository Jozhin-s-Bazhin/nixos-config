{ pkgs, username, ...}:
{
  nixpkgs.overlays = [
    (final: prev: {
      freecad = prev.freecad.overrideAttrs (oldAttrs: rec {
        python = final.python311Packages.python311;
        shiboken2 = final.python311Packages.shiboken2;
        pyside2 = final.python311Packages.pyside2;
        matplotlib = final.python311Packages.matplotlib;
        scipy = final.python311Packages.scipy;
        pyyaml = final.python311Packages.pyyaml;
        gitpython = final.python311Packages.gitpython;

        # Ensure that all build inputs are also using Python 3.11 packages
        buildInputs = oldAttrs.buildInputs ++ [
          final.python311Packages.python311
          final.python311Packages.shiboken2
          final.python311Packages.pyside2
          final.python311Packages.matplotlib
          final.python311Packages.scipy
          final.python311Packages.pyyaml
          final.python311Packages.gitpython
        ];
      });
    })
  ];

  home-manager.users.${username}.home.packages = with pkgs; [ freecad ];
}
