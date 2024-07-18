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
  modules = import ./modules.nix { inherit lib; };
in
  lib.nixosSystem {
    system = architecture;
    specialArgs = { inherit inputs architecture name username configDir; };
    inherit modules;
  }
