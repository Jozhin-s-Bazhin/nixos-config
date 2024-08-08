{
  description = "Roman's NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable/";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    stylix.url = "github:danth/stylix/";
    ags.url = "github:Aylur/ags";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1&ref=9a09eac79b85c846e3a865a9078a3f8ff65a9259";
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
	  ];
      };
    };
  };
}
