const hyprland = await Service.import("hyprland")
import { Bar } from "./bar.js";

let bars = hyprland.monitors.map(monitor => Bar(monitor.id))  // Open bars on all monitors

Utils.watch("", hyprland, "event", (name, data) => {
  // Makes workspaces always be on the focused monitor
  if (name == "focusedmon") {
    const monname = data.split(",")[0]  // monname is the name of the newly focused monitor, e.g 'eDP-1'
    const inactive_workspaces = () => {
      let active_workspaces = []
      for (let monitor in hyprland.monitors) {
        active_workspaces.push(monitor["activeWorkspace"]["id"])
      }        
      return () => hyprctl.workspaces.filter(workspace => !active_workspaces.includes(workspace.id))
    }
    
    let batch = [];
    for (let workspace in inactive_workspaces) {
      batch.push(`moveworkspacetomonitor ${workspace} ${monname}`)
    }
    batch = batch.join(";")
    
    hyprland.message(`--batch "${batch}"`)
  }
  // Open/close new bars when monitors are added/removed
  else if (name == "monitoradded" ) {
    const monitorid = data.split(",")[1]  // We only need monitorid
    bars.push(Bar(monitorid))
  }
  else if (name == "monitorremoved") {
    const monitorname = data
    // Get the Monitor object corresponding to monitorname
    for (const monitor of hyprland.monitors) {
      if (monitor.name == monitorname) {  
        // Get a bar on that monitor
        for (let i = 0; i < bars.length; i++) {
          if (bars[i].monitor == monitor.id) {
            bars[i].destroy()  // Close bar
            bars.splice(i, 1)  // Delete bar from list
            break
          }
        }
      }
    }
  }
})