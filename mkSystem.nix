{ inputs, ... }:

{ name, system }:

inputs.nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = { inherit inputs; };
  modules = [
    ./modules
    ./hosts/${name}.nix
    ./hardware/${name}.nix
    { networking.hostName = name; }
  ];
}
