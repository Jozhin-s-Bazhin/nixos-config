{
  description = "Roman's NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable/";
    nixpkgs-stable.url = "nixpkgs/nixos-24.05/";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    stylix.url = "github:danth/stylix/"; 
    #stylix.url = "git+file:///home/roman/Documents/Coding/stylix"; 
    ags.url = "github:Aylur/ags";
  };

  outputs = inputs@{ nixpkgs, nixpkgs-stable, home-manager, hyprland, nixos-hardware, ... }: {
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
	];
      };
    };
  };
}
