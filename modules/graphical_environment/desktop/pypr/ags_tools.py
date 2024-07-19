from pyprland.plugins.interface import Plugin
import subprocess

class Extension(Plugin):
    """A plugin that provides some useful features for ags like opening ags widgets when new monitors are connected"""
    async def list_monitors(self):
        monitors_dict = self.hyprctlJSON("monitors")
        monitors_list = [monitor["id"] for monitor in monitors_dict]
        return monitors_list


    async def on_reload(self):
        # Restart AGS
        subprocess.run(["ags", "-q"])
        subprocess.run(["ags"])
        
        # Open needed bars
        monitors = await self.list_monitors()
        for monitor in monitors:
            subrprocess.run()
           
    async def event_monitoraddedv2(self, monitor):


    async def event_monitorremovedv2(self, monitor):

