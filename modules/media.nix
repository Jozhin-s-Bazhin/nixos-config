{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.nixos-config.media.enable = lib.mkEnableOption "everything needed to watch movies or read";

  config = lib.mkIf config.nixos-config.media.enable {
    nixos-config.desktop.enable = lib.mkDefault true;
    home-manager.users.${config.nixos-config.username}.home.packages = with pkgs; [
      stremio
      foliate
    ];
  };
}
