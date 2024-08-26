import { NotificationPopups } from "./notifications.js"
import { Sidebar } from "./sidebar.js"
import { BrightnessOsd, VolumeOsd } from "./osd.js"
import "./better_multimonitor.js"

App.config({
  style: "./style.css",
  windows: [
    NotificationPopups(),
    Sidebar(),
    BrightnessOsd(),
    VolumeOsd()
  ]
})
