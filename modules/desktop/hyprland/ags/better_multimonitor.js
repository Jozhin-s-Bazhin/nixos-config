const hyprland = await Service.import("hyprland");
import { Bar } from "./bar.js";

hyprland.monitors.map((monitor) => Bar(monitor.id)); // Open bars on all monitors

hyprland.connect("event", (_, name, data) => {
  // Makes workspaces always be on the focused monitor
  /*if (name == "focusedmon") {
    const monname = data.split(",")[0]  // monname is the name of the newly focused monitor, e.g 'eDP-1'
    const inactive_workspaces = (() => {
      let active_workspaces = []
      for (let monitor of hyprland.monitors) {
        active_workspaces.push(monitor["activeWorkspace"]["id"])
      }
      const all_workspaces = hyprland.workspaces

      return all_workspaces
      .filter(workspace => !active_workspaces.includes(workspace.id))
      .map(workspace => workspace.id)
      .filter(id => id >= 0)
    })()

    let batch = [];
    for (let workspace of inactive_workspaces) {
      batch.push(`dispatch moveworkspacetomonitor ${workspace} ${monname}`)
    }
    batch = batch.join(" ; ")

    const message = `hyprctl --batch '${batch}'`
    Utils.exec(message)
  }*/
  // Open new bars when monitors are connected
  if (name == "monitoraddedv2") {
    Utils.execAsync(
      'bash -c "ags -q && ags -c ~/nixos-config/modules/desktop/hyprland/ags/config.js"',
    );
  }
});
