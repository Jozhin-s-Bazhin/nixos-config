from pyprland.plugins.interface import Plugin
import subprocess
from time import sleep

async def remove_unused_bars(self):
    monitors_json = await self.hyprctl_json("monitors")
    monitors = [ monitor["id"] for monitor in monitors_json ]
    for monitor in range(3): 
        if monitor not in monitors:
            subprocess.run(["ags", "-t", f"bar-{monitor}"])
 
class Extension(Plugin):
    """A plugin that provides some useful features for ags like opening ags widgets when new monitors are connected"""

    async def on_reload(self):
        sleep(1)
        await remove_unused_bars(self)

    async def event_monitoraddedv2(self, monitor):
        print(f"monitoradd start {monitor}")
        monitor_id = monitor.split(",")[0]
        #time.sleep(3)
        #command = ["ags", "-r", f"bar-{monitor_id}"]
        subprocess.run(["ags", "-q"])
        subprocess.run("ags & disown", shell=True)
        sleep(1)
        await remove_unused_bars(self)