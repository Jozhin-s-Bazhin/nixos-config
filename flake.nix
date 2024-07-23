{
  description = "Roman's NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable/";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    stylix.url = "github:danth/stylix/?rev=29148118cc33f08b71058e1cda7ca017f5300b51";  # Pin until the cursor is fixed
    ags.url = "github:Aylur/ags";
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
	  "qemu"
	  "cad"
	  "office"
	  "movies"
	];
      };
    };
  };
}
