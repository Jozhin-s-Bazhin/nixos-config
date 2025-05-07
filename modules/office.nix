{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.nixos-config.office.enable = lib.mkEnableOption "the office suite";

  config = lib.mkIf config.nixos-config.office.enable {
    nixos-config.desktop.enable = lib.mkDefault true;
    home-manager.users.${config.nixos-config.username}.home.packages = with pkgs; [
      onlyoffice-bin
    ];
  };
}
