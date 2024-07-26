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
        "ags -c ${configDir}/modules/desktop/ags"
        "pypr"
      ];
    };

    xdg.configFile."hypr/pyprland.toml".text = ''
      [pyprland]
      plugins = [
        "external:better_workspaces",
        "external:ags_tools"
      ]
      plugins_paths = [
        "${configDir}/modules/desktop/pypr"
      ]
    '';

    home.packages = with pkgs; [
      pyprland
      cliphist
      wl-clipboard-rs
    ];
  };
}
