{ pkgs, username, configDir, ... }:
{
  home-manager.users.${username} = {
    wayland.windowManager.hyprland.settings.exec-once = [ "pypr" ];
    home.packages = [ pkgs.pypr ];
    xdg.configFile = {
      "hypr/pyprland.toml".text = ''
        [pyprland]
        plugins = [
          "external:better_workspaces",
          "external:ags_tools"
        ]
        plugins_paths = [
          "/home/${username}/.config/pypr/"
        ]
      '';
      "pypr/ags_tools.py".text = ''
        from pyprland.plugins.interface import Plugin
        import subprocess
        from time import sleep

        def restart_ags():
          subprocess.run(["ags", "-q"])
          subprocess.run("ags -c ${configDir}/modules/desktop/hyprland/ags/config.js -b ags-$HYPRLAND_INSTANCE_SIGNATURE & disown", shell=True)

 
        class Extension(Plugin):
          """A plugin that provides some useful features for ags like opening ags widgets when new monitors are connected"""

          async def on_reload(self):
            restart_ags()

          async def event_monitoraddedv2(self, monitor):
            restart_ags()
      '';
      "pypr/better_workspaces.py".source = ./better_workspaces.py;
    };
  }
}
