{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.nixos-config.desktop.desktop == "hyprland") {
    home-manager.users.${config.nixos-config.username}.wayland.windowManager.hyprland = {
      plugins = [
        pkgs.hyprlandPlugins.hyprspace
      ];

      settings.permission = [ "${pkgs.hyprlandPlugins.hyprspace}/lib/libhyprspace.so, plugin, allow" ];
      settings.plugin = {
        overview = {
          dragAlpha = 1;
          panelHeight = 200;
          hideTopLayers = true;
          workspaceActiveBorder = "rgba(00000000)";
          workspaceInactiveBorder = "rgba(00000000)";
          #showNewWorkspace = false;
          showEmptyWorkspace = false;
          affectStrut = false;
        };
      };
    };
  };
}
