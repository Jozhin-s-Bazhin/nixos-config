{ inputs }:
 
{
  name,
  architecture,
  username,  
  configDir ? "/home/${username}/nixos-config",
  moduleNames ? []
}:
let
  lib = inputs.nixpkgs.lib;
  hasModule = moduleName: lib.elem moduleName modules;
  modules = import ./modules { inherit lib; };
in
  lib.nixosSystem {
    system = architecture;
    specialArgs = { inherit inputs architecture name username configDir; };
    inherit modules;
  }
