import { Bars } from "./bar.js";
import { NotificationPopups } from "./notifications.js"
import { Sidebar } from "./sidebar.js"
import { BrightnessOsd, VolumeOsd } from "./osd.js"
import "./better_workspaces.js"

App.config({
  style: "./style.css",
  windows: [
    ...Bars(),
    NotificationPopups(),
    Sidebar(),
    BrightnessOsd(),
    VolumeOsd()
  ]
})
