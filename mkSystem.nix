{ inputs }:
 
{
  name,
  architecture,
  username,  
  configDir ? "/home/${username}/nixos-config",
  common ? true,
  desktop ? false,
  laptop ? false,
  server ? false,
  graphicalEnvironment ? false,
  gaming ? false,
  development ? false,
  amdgpu ? false,
  extraModules ? []
}:
let
  lib = inputs.nixpkgs.lib;
in
  lib.nixosSystem {
    system = architecture;
    specialArgs = { inherit inputs architecture name username configDir; };
    modules = 
      lib.optional common ./modules/common.nix ++
      lib.optional server ./modules/server.nix ++
      lib.optional desktop ./modules/pc.nix ++
      lib.optional amdgpu ./modules/amdgpu.nix ++
      lib.optional graphicalEnvironment ./modules/graphical_environment/graphical_environment.nix ++
      [ ./hardware-configuration/${name}.nix ] ++
      lib.optionals laptop [
        ./modules/pc.nix
        ./modules/laptop.nix
      ] ++
      lib.optionals gaming [
        ./modules/graphical_environment/graphical_environment.nix
        ./modules/gaming.nix
      ] ++
      lib.optionals development [
        ./modules/graphical_environment/graphical_environment.nix
        ./modules/development.nix
      ] ++
      extraModules;
  }
