{ inputs, pkgs, config, lib, ...}:
/*let
	freecad-custom = import ./freecad.nix { inherit pkgs; };
	custompkgs = import ./custompkgs { pkgs = pkgs; };
	openfoam = custompkgs.openfoam-2306;
	cfmesh = custompkgs.cfmesh-cfdof.override { openfoam = openfoam; };
	hisa = custompkgs.hisa.override { openfoam = openfoam; };
in*/
{
  options.nixos-config.cad.enable = lib.mkEnableOption "everything needed for cad";

  config = lib.mkIf config.nixos-config.cad.enable {
    nixos-config.desktop.enable = lib.mkDefault true;
    home-manager.users.${config.nixos-config.username}.home.packages = with pkgs; [ 
      #freecad-custom
      freecad-wayland
      openscad
      orca-slicer
      geogebra6
      /*openfoam
      cfmesh
      hisa
      paraview*/
    ];
  };
}
