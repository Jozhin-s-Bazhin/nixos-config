{ inputs, pkgs, username, ...}:
{
  home-manager.users.${username}.home.packages = with pkgs; [ 
    (freecad-wayland.overrideAttrs (oldAttrs: rec {
      buildInputs = oldAttrs.buildInputs ++ [
        pkgs.python312Packages.gmsh
	pkgs.gmsh
        pkgs.calculix
      ];
      postFixup = oldAttrs.postFixup + ''
        wrapProgram $out/bin/FreeCAD --prefix PATH : ${pkgs.calculix}/bin
        wrapProgram $out/bin/FreeCAD --prefix PATH : ${pkgs.gmsh}/bin
        wrapProgram $out/bin/FreeCAD --prefix PATH : ${pkgs.python312Packages.gmsh}/lib/python3.12/site-packages
      '';
    }))
    openscad
    orca-slicer
  ];
}
