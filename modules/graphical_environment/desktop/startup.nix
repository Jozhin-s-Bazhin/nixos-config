{ config, pkgs, username, configDir, ... }:

{
  home-manager.users.${username} = {
    wayland.windowManager.hyprland.settings = {
      exec-once = [
        # Polkit
        "lxqt-policykit-agent"

        # Clipboard manager
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"

        # Other
        "hyprpaper"
        "ags"
        "pypr"
        "wluma"
      ];
    };

    xdg.configFile."hypr/hypridle.conf".source = ./hypridle.conf;
    xdg.configFile."hypr/pyprland.toml".text = ''
      [pyprland]
      plugins = [
        "external:better_workspaces",
        "external:ags_tools"
      ]
      plugins_paths = [
        "${configDir}/modules/graphical_environment/desktop/pypr"
      ]
    '';
    home.packages = with pkgs; [
      pypr
      wluma
      cliphist
      wl-clipboard-rs
      hyprpaper
    ];
  };
}
