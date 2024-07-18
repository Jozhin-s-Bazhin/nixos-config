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
  moduleList = import ./modules.nix { inherit lib modules name; };
in
  lib.nixosSystem {
    system = architecture;
    specialArgs = { inherit inputs architecture name username configDir; };
    modules = moduleList;
  }
