{ lib, config, ... }:
{
  imports = [
    ./cad
    ./desktop
    ./virtualisation
    ./amdgpu.nix
    ./common.nix
    ./development.nix
    ./gaming.nix
    ./laptop.nix
    ./media.nix
    ./office.nix
    ./pc.nix
  ];
  
  options.nixos-config = {
    username = lib.mkOption {
      default = "user";
      type = lib.types.str;
			description = "Username of the user most of the config applies to.";
    };
    configDir = lib.mkOption {
      default = "/home/${config.nixos-config.username}/nixos-config/";
      type = lib.types.path;
			description = "Path to your nixos config. Must have a / at the end.";
    }; 
  };
}
