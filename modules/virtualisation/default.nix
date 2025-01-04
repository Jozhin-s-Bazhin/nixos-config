{ pkgs, lib, config, ... }:
{
  imports = [
    ./qemu.nix
    ./docker.nix
    ./waydroid.nix
  ];
  
  options.nixos-config.virtualisation.enable = lib.mkEnableOption "docker, qemu and waydroid";

  config.nixos-config.virtualisation = lib.mkIf config.nixos-config.virtualisation.enable {
    qemu.enable = lib.mkDefault true;
    docker.enable = lib.mkDefault true;
    waydroid.enable = lib.mkDefault true;
  };
}
