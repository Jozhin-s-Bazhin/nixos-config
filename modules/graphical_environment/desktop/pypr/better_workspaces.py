from pyprland.plugins.interface import Plugin


async def get_workspaces(self):
    workspaces = [ workspace["id"] for workspace in (await self.hyprctl_json("workspaces")) if workspace["id"] > 0 ]
    workspaces.sort()
    return workspaces

async def get_currentworkspace(self):
    monitors = await self.hyprctl_json("monitors")
    for monitor in monitors:
        if monitor["focused"]:
            return monitor["activeWorkspace"]["id"]

def insert_last_workspace(workspaceid):
    target = (MAX_WORKSPACE_ID - workspaceid) // 2
    print(target)
    return target
 
async def get_target_workspace(self, workspaceid):
    workspaces = await get_workspaces(self)

    if workspaceid == "new":
        return workspaces[-1] + 1

    elif "+" in workspaceid:
        currentworkspace = await get_currentworkspace(self)

        for i in range(len(workspaces)):
            if workspaces[i] == currentworkspace:
                if i + 1 >= len(workspaces):
                    return workspaces[i] + 1
                else:
                    return workspaces[i + 1]

    elif "-" in workspaceid:
        currentworkspace = await get_currentworkspace(self)

        for i in range(len(workspaces)):
            if workspaces[i] == currentworkspace:
                if workspaces[i] == 1:
                    return "No target workspace"
                elif i == 0:
                    return workspaces[i] - 1
                else:
                    return workspaces[i - 1]

    else:
        workspaceid = int(workspaceid)
        if workspaceid > len(workspaces):
            target = workspaces[-1] + 1 
        else:
            target = workspaces[workspaceid - 1]
        return target

async def move_workspaces_to_focused_mon(self, event_data):
    """Takes in a value the hyprland socket gives when changing monitors and moves all inactive windows to that monitor"""
    monname, workspacename = event_data.split(",")  # Where monname is the name of the monitor the cursor was just moved to (for example 'eDP-1')
    
    workspaces = await get_workspaces(self)
    active_workspaces = [ monitor["activeWorkspace"]["id"] for monitor in (await self.hyprctl_json("monitors")) ]

    batch = []
    for workspace in workspaces:
        if workspace not in active_workspaces:
            batch.append(f"moveworkspacetomonitor {workspace} {monname}")
            
    if batch:
        await self.hyprctl(batch)

class Extension(Plugin):
    """A plugin for better workspaces, similar to Gnome's workspace behaviour, with some other nice features like better multi-monitor behaviour and proper relative workspace controls"""

    async def event_focusedmon(self, event_data):
        await move_workspaces_to_focused_mon(self, event_data)
        
    async def run_workspace(self, workspaceid):
        target = await get_target_workspace(self, workspaceid)
        if target == "No target workspace": return
        await self.hyprctl(f"workspace {target}")
        
    async def run_movetoworkspace(self, workspaceid):
        target = await get_target_workspace(self, workspaceid)
        if target == "No target workspace": return
        await self.hyprctl(f"movetoworkspace {target}")
