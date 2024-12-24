{ inputs, pkgs, config, lib, ... }:
{
  config = lib.mkIf config.nixos-config.desktop.hyprland.enable {
    home-manager.users.${config.nixos-config.username}.wayland.windowManager.hyprland = {
      plugins = [
        pkgs.hyprlandPlugins.hyprspace
      ];

      settings.plugin = {
        overview = {
          dragAlpha = 1;
          panelHeight = 200;
          hideTopLayers = true;
          workspaceActiveBorder = "rgba(00000000)";
          workspaceInactiveBorder = "rgba(00000000)";
          showNewWorkspace = false;
        };
      };
    };
  };
}
