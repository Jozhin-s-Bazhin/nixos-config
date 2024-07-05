{ inputs, username, ... }:
{
  home-manager.users.${username}.wayland.windowManager.hyprland = {
    plugins = [
      #inputs.Hyprspace.packages."${pkgs.system}".Hyprspace
    ];

    settings = {
      plugin = {
        overview = {
          panelColor = "rgba(0, 0, 0, 0)";
          panelHeight = "125";
          showEmptyWorkspace = false;
          drawActiveWorkspace = true;

          overrideGaps = true;
          gapsIn = 5;
          gapsOut = 10;
        };
      };
    };
  };
}
