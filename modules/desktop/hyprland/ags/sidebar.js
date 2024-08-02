const hyprland = await Service.import("hyprland")

function sidebar_box() {
  return Widget.Box({
    children: [

    ]
  })
}

export function Sidebar() {
  const monitor = hyprland.active.monitor.bind("id")
  
  return Widget.Window({
    monitor,
    name: `sidebar`,
    class_name: "sidebar",
    anchor: ["top", "left", "bottom"],
    child: sidebar_box(),
    visible: false,
  })
}