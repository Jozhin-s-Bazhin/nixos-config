# FreeCAD FEM and cfdOF workbench setup

*****

1. Install the workbenches trough the FreeCAD addon manager

2. Run this command:

```
cp -r /run/current-system/sw/share/openfoam/OpenFOAM-v2306 /home/<username>/OpenFOAM
```

3. Add the following to their corresponding options

	- `/home/\<username\>/OpenFOAM` to `CfdOF > OpenFOAM install directory`
	- `/run/current-system/sw/bin/paraview` to `CfdOF > ParaView executable`
	- `/run/current-system/sw/bin/gmsh` to `CfdOF > gmsh executable` and `FEM > Gmsh > Gmsh binary path`
	- `/run/current-system/sw/bin/calculix` to `FEM > CalculiX > ccx binary path`
	- `/run/current-system/sw/bin/cfMesh` to `CfdOF > cfMesh`
	- `/run/current-system/sw/bin/hisa` to `CfdOF > HiSA`
