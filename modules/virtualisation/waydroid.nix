{ lib, config, ... }:
{
  options.nixos-config.virtualisation.waydroid.enable =
    lib.mkEnableOption "the waydroid android translation layer";

  config = lib.mkIf config.nixos-config.virtualisation.waydroid.enable {
    virtualisation.waydroid.enable = true; # Yes this is way too much boilerplate but this will be useful if I want to add stuff in the future
  };
}
