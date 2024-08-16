const hyprland = await Service.import("hyprland")
const mpris = await Service.import("mpris")
const audio = await Service.import("audio")
const battery = await Service.import("battery")
const systemtray = await Service.import("systemtray")
const network = await Service.import("network")
const bluetooth = await Service.import('bluetooth')

const date = Variable('');
const time = Variable('');
const updateDateTime = () => {
  const output = Utils.exec('date "+%H:%M& ~ %A, %B %d"')
  const output_list = output.split('&')
  time.value = output_list[0]
  date.value = output_list[1]
};
Utils.interval(60000, updateDateTime)

function Workspaces() {
  const activeId = hyprland.active.workspace.bind("id")
  const workspaces = hyprland.bind("workspaces").as((ws) =>
    ws
      .filter(({ id }) => id > 0)
      .sort((a, b) => a.id - b.id)
      .map(({ id }) =>
        Widget.Button({
          on_clicked: () => hyprland.messageAsync(`dispatch workspace ${id}`),
          class_name: activeId.as((i) => `${i === id ? "focused" : ""}`),
        })
      )
  );

  return Widget.Box({
    class_name: "workspaces",
    children: workspaces,
  });
}

function Clock() {
  const timeLabel = Widget.Label({ label: time.bind() })
  const dateLabel = Widget.Revealer({
    child: Widget.Label({ label: date.bind() }),
    revealChild: false,
    transition: "slide_left",
  })
  
  return Widget.EventBox({
    child: Widget.Box({
      children: [
        timeLabel,
        dateLabel
      ],
    }),
    class_name: "clock",
    on_hover: () => dateLabel.reveal_child = true,
    on_hover_lost: () => dateLabel.reveal_child = false,
    setup: self => updateDateTime(),
  })
}

function Bluetooth() {
  const icon = Utils.merge([bluetooth.bind("connected-devices"), bluetooth.bind("enabled")], (devices, enabled) => {
    if (enabled) {
      if (devices[0]) { return "bluetooth-active-symbolic" } 
      else { return "bluetooth-disconnected-symbolic" }
    } 
    else { return "bluetooth-disabled-symbolic" }
  })

  return Widget.Button ({
    child: Widget.Icon ({ icon: icon }),
    on_clicked: () => bluetooth.toggle(),
    tooltip_text: bluetooth.bind("connected-devices").as (devices => devices[0] ? `${devices[0].name}` : "No devices connected" )
  })
}

function Media() {
  const prevButton = Widget.Button({
    on_clicked: () => mpris.getPlayer("")?.previous(),
    child: Widget.Icon("media-skip-backward-symbolic"),
  })
  const nextButton = Widget.Button({
    on_clicked: () => mpris.getPlayer("")?.next(),
    child: Widget.Icon("media-skip-forward-symbolic")
  })
  const pauseButton = Widget.Button({
    on_clicked: () => mpris.getPlayer("")?.playPause(),
    child: Widget.Icon({ 
      icon: Utils.watch("", mpris, "changed", () => {
        if (mpris.players[0]) {
          if (mpris.players[0].playBackStatus == "Playing") {
            return "media-playback-pause-symbolic"
          } else {
            return "media-playback-start-symbolic"
          }
        } else {
          return "media-playback-start-symbolic"
        }
      }) 
    })
  })
  
  return Widget.Box({
    children: [
      prevButton,
      pauseButton,
      nextButton,
    ],
    class_name: "media",
    visible: mpris.bind("players").as(p => p.length > 0),
  })
}

function Volume() {
  const icons = {
    101: "overamplified",
    67: "high",
    34: "medium",
    1: "low",
    0: "muted",
  }

  function getIcon() {
    const icon = audio.speaker.is_muted ? 0 : [101, 67, 34, 1, 0].find(
      threshold => threshold <= audio.speaker.volume * 100)

    return `audio-volume-${icons[icon]}-symbolic`
  }

  const icon = Widget.Button ({
    child: Widget.Icon({
      icon: Utils.watch(getIcon(), audio.speaker, getIcon),
    }),
    on_clicked: () => audio.speaker.is_muted = !audio.speaker.is_muted,
    className: "volumeIndicator",
  })

  return Widget.Box({
    class_name: "volume",
    child: icon,
  })
}

function BatteryLabel() {
  const icon = battery.bind("icon-name").as(icon => icon)
  /*const percentage = battery.bind("percent").as(p => `${p}%`)

  const revealer = Widget.Revealer ({
    child: Widget.Label ({ label: percentage }),
    reveal_child: false,
    transition: "slide_left",
  })

  return Widget.EventBox({
    child: Widget.Box ({
      children: [
        Widget.Icon({ icon: icon }),
        revealer
      ],
      class_name: "battery"
    }),
    visible: battery.bind("available"),
    on_hover: () => revealer.reveal_child = true,
    on_hover_lost: () => revealer.reveal_child = false,
  })*/
  
  return Widget.Icon({
    icon: icon,
    class_name: "battery",
    visible: battery.bind("available"),
  })
}

function SysTray() {
  const items = systemtray.bind("items")
    .as(items => items.map(item => Widget.Button({
      child: Widget.Icon({ icon: item.bind("icon") }),
      on_secondary_click: (_, event) => item.activate(event),
      on_primary_click: (_, event) => item.openMenu(event),
      tooltip_markup: item.bind("tooltip_markup"),
    })))

  return Widget.Box({
    children: items,
    class_name: "tray",
  })
}

const WifiIndicator = () => Widget.Icon({ icon: network.wifi.bind('icon_name'), })
const WiredIndicator = () => Widget.Icon({ icon: network.wired.bind('icon_name'), })
const NetworkIndicator = () => Widget.Stack({
  children: {
    wifi: WifiIndicator(),
    wired: WiredIndicator(),
  },
  shown: network.bind('primary').as(p => p || 'wifi'),
})


// layout of the bar
function Left() {
  return Widget.Box({
    spacing: 8,
    children: [
      Workspaces(),
    ],
  })
}

function Center() {
  return Widget.Box({
    spacing: 8,
    children: [
      Clock(),
    ],
  })
}

function Right() {
  return Widget.Box({
    hpack: "end",
    spacing: 8,
    children: [
      SysTray(),
      Media(),
      Bluetooth(),
      Volume(),
      NetworkIndicator(),
      BatteryLabel(),
    ],
  })
}

export function Bars() {
  const monitors = hyprland.monitors.map(monitor => monitor.id)
  return monitors.map(monitor =>
    Widget.Window({
      name: `bar-${monitor}`,
      class_name: "bar",
      monitor: monitor,
      anchor: ["top", "left", "right"],
      exclusivity: "exclusive",
      child: Widget.CenterBox({
        start_widget: Left(),
        center_widget: Center(),
        end_widget: Right(),
      }),
    })
  )
}
