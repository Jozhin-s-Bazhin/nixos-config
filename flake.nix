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
    stylix.url = "github:danth/stylix/f13c946181730f98e1a5cd09714100490207b250";  # Old version because bug
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

        laptop = true;
        amdgpu = true;
        gaming = true;
        development = true;

        extraModules = [
          nixos-hardware.nixosModules.framework-16-7040-amd
          {
            boot = {
              kernelPackages = nixpkgs.legacyPackages."x86_64-linux".linuxPackages_latest;  # Proper shutdown
              kernelParams = [ "usbcore.autosuspend=60" ];  # Fix autosuspend issues
            };
            services.fwupd.enable = true;  # Firmware updates 
          }
        ];
      };
    };
  };
}
