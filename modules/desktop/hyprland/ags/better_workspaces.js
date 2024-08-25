const hyprland = await Service.import("hyprland")

// Makes workspaces always be on the focused monitor
Utils.watch("", hyprland, "event", (name, data) => {
  if (name == "focusedmon") {
    const [monname, workspacename] = data.split(",")  // monname is the name of the newly focused monitor, e.g 'eDP-1', workspacename isn't used
    const inactive_workspaces = () => {
      let active_workspaces = []
      for (let monitor in hyprland.monitors) {
        active_workspaces.append(monitor["activeWorkspace"]["id"])
      }        
      return () => hyprctl.workspaces.filter(workspace => !active_workspaces.includes(workspace.id))
    }
    
    let batch = [];
    for (let workspace in inactive_workspaces) {
      batch.append(`moveworkspacetomonitor ${workspace} ${monname}`)
    }
    batch = batch.join(";")
    
    hyprland.message(`--batch "${batch}"`)
  }
})