const hyprland = await Service.import("hyprland")
import { Bar } from "./bar.js";

hyprland.monitors.map(monitor => Bar(monitor.id))  // Open bars on all monitors

hyprland.connect("event", (_, name, data) => {
  // Makes workspaces always be on the focused monitor
  if (name == "focusedmon") {
    const monname = data.split(",")[0]  // monname is the name of the newly focused monitor, e.g 'eDP-1'
    const inactive_workspaces = (() => {
      let active_workspaces = []
      for (let monitor in hyprland.monitors) {
        active_workspaces.push(monitor["activeWorkspace"]["id"])
      }        
      return hyprland.workspaces.filter(workspace => !active_workspaces.includes(workspace.id))
    })()
    
    let batch = [];
    for (let workspace in inactive_workspaces) {
      batch.push(`moveworkspacetomonitor ${workspace} ${monname}`)
    }
    batch = batch.join(";")
    
    hyprland.message(`--batch "${batch}"`)
  }
  // Open/close new bars when monitors are added/removed
  else if (name == "monitoraddedv2" ) {
    const monitorid = data.split(",")[0]  // We only need monitorid
    
    print(monitorid)
    print(JSON.stringify(hyprland.monitors))
    Bar(monitorid)
  }
})
