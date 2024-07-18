{ inputs }:
 
{
  name,
  architecture,
  username,  
  configDir ? "/home/${username}/nixos-config",
  modules ? []
}:
let
  lib = inputs.nixpkgs.lib;
  getModules = import ./modules.nix { inherit lib name; };
in
  lib.nixosSystem {
    system = architecture;
    specialArgs = { inherit inputs architecture name username configDir; };
    modules = getModules modules;
  }
