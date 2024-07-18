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
  module_func = import ./modules.nix { inherit lib; };
  modules = module_func moduleNames;
in
  lib.nixosSystem {
    system = architecture;
    specialArgs = { inherit inputs architecture name username configDir; };
    inherit modules;
  }
