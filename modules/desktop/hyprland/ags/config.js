import { NotificationPopups } from "./notifications.js"
import { Sidebar } from "./sidebar.js"
import { VolumeOsd } from "./osd.js"
import "./better_multimonitor.js"

App.config({
  style: "./style.css",
  icons: "./assets",
  windows: [
    NotificationPopups(),
    Sidebar(),
    //BrightnessOsd(),
    VolumeOsd()
  ]
})
