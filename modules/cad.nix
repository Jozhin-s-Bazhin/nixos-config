{ inputs, pkgs, username, ...}:
{
  home-manager.users.${username}.home.packages = with pkgs; [ 
    (freecad-wayland.overrideAttrs (oldAttrs: rec {
      buildInputs = oldAttrs.buildInputs ++ [
        pkgs.python312Packages.gmsh
	pkgs.gmsh
        pkgs.calculix
      ];
    }))
    openscad
    orca-slicer
  ];
}
