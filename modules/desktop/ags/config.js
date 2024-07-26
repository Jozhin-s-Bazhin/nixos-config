import { Bars } from "./bar.js";
import { NotificationPopups } from "./notifications.js"
import { applauncher } from "./applauncher.js";

App.config({
  style: "./style.css",
  windows: [
	  Bars(),
	  NotificationPopups(),
	  applauncher
  ]
})
