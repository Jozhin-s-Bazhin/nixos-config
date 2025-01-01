{ inputs, pkgs, config, lib, ...}:
let
	custompkgs = import ./custompkgs { pkgs = pkgs; };
	openfoam = custompkgs.openfoam-2306;
	cfmesh = custompkgs.cfmesh-cfdof.override { openfoam = openfoam; };
	hisa = custompkgs.hisa.override { openfoam = openfoam; };
in
{
  options.nixos-config.cad.enable = lib.mkEnableOption "everything needed for cad";

  config = lib.mkIf config.nixos-config.cad.enable {
    nixos-config.desktop.enable = lib.mkDefault true;
    home-manager.users.${config.nixos-config.username}.home.packages = with pkgs; [ 
      freecad-wayland
      openscad
      orca-slicer
      geogebra6
     
      # FreeCAD cfd and fea dependencies
      openfoam
      paraview
      gmsh
      hisa
      cfmesh

      /*
      To use the cfdof and fem workbench you'll have to add these dependencies manually trough the preferences. You
      will also have to copy ${pkgs.openfoam}/opt/OpenFOAM/OpenFOAM-v2306 to somewhere in your home and add that as the
      openfoam install directory. This is needed because freecad wants the openfoam install directory to be writeable,
      which is not achievable without wrapping freecad in an fsh env which I am way too lazy to try. That would also 
      require to override the freecad package and I do not want to wait for it to recompile every update.
      */
    ];
  };
}
