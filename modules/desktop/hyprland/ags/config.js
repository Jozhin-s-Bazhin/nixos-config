import { Bars } from "./bar.js";
import { NotificationPopups } from "./notifications.js"
import { Sidebar } from "./sidebar.js"
import { BrightnessOsd, VolumeOsd } from "./osd.js"

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
