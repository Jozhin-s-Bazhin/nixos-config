import Gtk from 'gi://Gtk'
import { applauncher } from './sidebar_modules/applauncher.js'

const notebook = Widget.subclass(Gtk.Notebook)  // Tabby thing

const sidebar_notebook = () => notebook({
  setup: self => {
    self.set_tab_pos(Gtk.PositionType.RIGHT);

    const pages = [
      applauncher
    ]
    
    for (const page of pages) {
      self.append_page(Widget.Icon({ icon: page[0] }), page[1])
    }
  }
})

export function Sidebar() {
  return Widget.Window({
    name: `sidebar`,
    class_name: "sidebar",
    anchor: ["top", "left", "bottom"],
    visible: false,
    keymode: "exclusive",
    child: sidebar_notebook(),
    setup: self => self.keybind("Escape", () => {
      App.closeWindow("sidebar")
    })
  })
}
