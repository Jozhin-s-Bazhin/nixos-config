import { Bars } from "./bar.js";
import { NotificationPopups } from "./notifications.js"
import { Sidebar } from "./sidebar.js"

App.config({
  style: "./style.css",
  icons: "./assets",
  windows: [
    ...Bars(),
    NotificationPopups(),
    Sidebar()
  ]
})
