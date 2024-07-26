from pyprland.plugins.interface import Plugin
import subprocess
from time import sleep

def restart_ags():
    subprocess.run(["ags", "-q"])
    subprocess.run("ags & disown", shell=True)

 
class Extension(Plugin):
    """A plugin that provides some useful features for ags like opening ags widgets when new monitors are connected"""

    async def on_reload(self):
        restart_ags()

    async def event_monitoraddedv2(self, monitor):
        restart_ags()
