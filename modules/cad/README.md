# FreeCAD FEM and cfdOF workbench setup

*****

1. Install the workbenches trough the FreeCAD addon manager

2. Run this command:

```
cp -r ~/.local/state/nix/profiles/home-manager/home-path/opt/OpenFOAM/OpenFOAM-v2306/ ~/OpenFOAM
```

3. Add the following to their corresponding options

	- `/home/<username>/OpenFOAM` to `CfdOF > OpenFOAM install directory`
	- `/home/<username>/.local/state/nix/profiles/home-manager/home-path/bin/paraview` to `CfdOF > ParaView executable`
	- `/home/<username>/.local/state/nix/profiles/home-manager/home-path/bin/gmsh` to `CfdOF > gmsh executable` and `FEM > Gmsh > Gmsh binary path`
	- `/home/<username>/.local/state/nix/profiles/home-manager/home-path/bin/ccx` to `FEM > CalculiX > ccx binary path`
