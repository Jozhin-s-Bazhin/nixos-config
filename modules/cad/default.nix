{ inputs, pkgs, username, lib, ...}:
/*let
	freecad-custom = import ./freecad.nix { inherit pkgs; };
	custompkgs = import ./custompkgs { pkgs = pkgs; };
	openfoam = custompkgs.openfoam-2306;
	cfmesh = custompkgs.cfmesh-cfdof.override { openfoam = openfoam; };
	hisa = custompkgs.hisa.override { openfoam = openfoam; };
in*/
{
	home-manager.users.${username}.home.packages = with pkgs; [ 
		#freecad-custom
		freecad-wayland
		openscad
		orca-slicer
		/*openfoam
		cfmesh
		hisa
		paraview*/
	];
}
