{ config, lib, ... }:

{
  options.nixos-config.laptop.enable = lib.mkEnableOption "stuff you want on a laptop";

  config = lib.mkIf config.nixos-config.laptop.enable {
    # Networking
    networking.networkmanager.enable = true; # I assume you have ethernet on a desktop
    networking.wireless.iwd.enable = true;
    networking.networkmanager.wifi.backend = "iwd";
    users.users.${config.nixos-config.username}.extraGroups = [ "networkmanager" ];

    # Enable the custom pc module
    nixos-config.pc.enable = lib.mkDefault true;
  };
}
