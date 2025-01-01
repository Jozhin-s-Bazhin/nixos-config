# FreeCAD FEM and cfdOF workbench setup

*****

1. Install the workbenches trough the FreeCAD addon manager

2. Run this command:

```
cp -r ~/.local/state/nix/profiles/home-manager/home-path/opt/openfoam/OpenFOAM-v2306 ~/OpenFOAM
```

3. Add the following to their corresponding options

	- `~/OpenFOAM` to `CfdOF > OpenFOAM install directory`
	- `~/.local/state/nix/profiles/home-manager/home-path/bin/paraview` to `CfdOF > ParaView executable`
	- `~/.local/state/nix/profiles/home-manager/home-path/bin/gmsh` to `CfdOF > gmsh executable` and `FEM > Gmsh > Gmsh binary path`
	- `~/.local/state/nix/profiles/home-manager/home-path/bin/ccx` to `FEM > CalculiX > ccx binary path`
