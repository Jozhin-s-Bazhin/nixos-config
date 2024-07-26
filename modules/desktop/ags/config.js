import { Bars } from "./bar.js";
import { NotificationPopups } from "./notifications.js"
import { applauncher } from "./applauncher.js";

App.config({
  style: "./style.css",
  windows: [
    Bars(), // This returns a list but it still works somehow
    NotificationPopups(),
    applauncher
  ]
})
