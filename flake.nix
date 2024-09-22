{
  description = "Roman's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/6c4ea7a3e0cf72ef7b67bddc05fdfc66d5cdfafc";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    stylix.url = "github:danth/stylix/";
    ags.url = "github:Aylur/ags";
    cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, ... }: {
    nixosConfigurations = let
      mkSystem = import ./mkSystem.nix { inherit inputs; };
    in {
      framework = mkSystem {
        name = "framework";
        architecture = "x86_64-linux";
        username = "roman";
	  modules = [
            "laptop"
            "amdgpu"
            "gaming"
            "development"
	    "cad"
	    "office"
	    "movies"
	    "docker"
	    "qemu"
	  ];
      };
    };
  };
}
