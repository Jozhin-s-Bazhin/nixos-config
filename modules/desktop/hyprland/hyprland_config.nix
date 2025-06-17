{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:

let
  hyprlandPackage = pkgs.hyprland;
  portalPackage = pkgs.xdg-desktop-portal-hyprland;
in
{
  config = lib.mkIf (config.nixos-config.desktop.desktop == "hyprland") {
    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
    programs.dconf.enable = true;

    home-manager.users.${config.nixos-config.username} = {
      dconf.enable = true;
      gtk.enable = true;

      wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;
        systemd.enable = false;
        package = hyprlandPackage;
        portalPackage = portalPackage;
      };

      programs.zsh.shellAliases."rm" = "${pkgs.rmtrash}/bin/rmtrash";
      programs.zsh.shellAliases."rmdir" = "${pkgs.rmtrash}/bin/rmdirtrash";
    };

    programs.hyprland = {
      enable = true;
      withUWSM = true;
      package = hyprlandPackage;
      portalPackage = portalPackage;
    };

    services.gvfs.enable = true;

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      XDG_SESSION_TYPE = "wayland";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      QT_QPA_PLATFORM = "wayland;xcb";
    };

    xdg = {
      autostart.enable = true;
      portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      };
    };
    services.dbus.enable = true;
  };
}
