{ lib, config, ... }:
{
  options.nixos-config.virtualisation.docker.enable = lib.mkEnableOption "docker and configure rootless access";

  config = lib.mkIf config.nixos-config.virtualisation.docker.enable {
    virtualisation.docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };
}
