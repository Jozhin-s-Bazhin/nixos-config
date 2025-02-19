{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.nixos-config.desktop.hyprland.enable {
    home-manager.users.${config.nixos-config.username}.wayland.windowManager.hyprland = {
      plugins = [
        #pkgs.hyprlandPlugins.hyprspace
        pkgs.hyprlandPlugins.hyprscroller
      ];

      settings.plugin = {
        /*
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
        */
        scroller = {
          column_default_width = "one";
          focus_wrap = "false";
          mode = "row";
          monitor_options = "(eDP-2 = (mode = row; column_default_width = one; column_widths = one onehalf; window_default_height = one), DP-1 = (mode = row; column_default_width = onethird; window_default_height = one))";
        };
      };
    };
  };
}
