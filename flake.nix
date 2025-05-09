{
  description = "Roman's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    nixpkgs.follows = "nixos-cosmic/nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags = {
      url = "github:Aylur/ags/67b0e31ded361934d78bddcfc01f8c3fcf781aad";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
  };

  outputs =
    inputs@{ nixpkgs, ... }:
    {
      nixosConfigurations =
        let
          mkSystem = import ./mkSystem.nix { inherit inputs; };
        in
        {
          framework = mkSystem {
            name = "framework";
            system = "x86_64";
          };
        };
    };
}
