import { Bar } from "./bar.js";
import { NotificationPopups } from "./notifications.js"
import { applauncher } from "./applauncher.js";

App.config({
    style: "./style.css",
    windows: [
	Bar(0),
	Bar(1),
	Bar(2),
	NotificationPopups(),
	applauncher
    ]
})
