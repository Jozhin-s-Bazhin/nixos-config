{
	description = "Roman's NixOS configuration";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		nixos-hardware.url = "github:NixOS/nixos-hardware/master";

		stylix.url = "github:danth/stylix/";
		ags.url = "github:Aylur/ags/67b0e31ded361934d78bddcfc01f8c3fcf781aad";
		zen.url = "github:youwen5/zen-browser-flake";
	};

	outputs = inputs@{ nixpkgs, ... }: {
    nixosConfigurations = let 
      mkSystem = import ./mkSystem.nix { inherit inputs; };
    in {
      framework = mkSystem {
				name = "framework";
				system = "x86_64";
			};
    };
  };
}
