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
    home-manager.users.${config.nixos-config.username}.home.packages =
      (
        if config.nixos-config.desktop.desktop == "plasma" then
          with pkgs;
          [
            kdePackages.okular
            qmplay2
            qbittorrent
          ]
        else
          with pkgs;
          [
            foliate
            celluloid
            fragments
          ]
      )
      ++ [ pkgs.stremio ];
  };
}
