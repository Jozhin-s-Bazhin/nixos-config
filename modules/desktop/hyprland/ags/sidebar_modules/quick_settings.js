const network = await Service.import('network')
const bluetooth = await Service.import('bluetooth')
const audio = await Service.import('audio')
const powerprofiles = await Service.import('powerprofiles')
import brightness from '../services/brightness.js';


// Power profiles
function powerprofileButton(profile) {
  return Widget.Button({
    child: Widget.Icon(`power-profile-${profile}-symbolic`),
    onClicked: () => powerprofiles.active_profile = profile,
    tooltipText: profile,
    class_name: powerprofiles.bind("active-profile").as(p => p == profile ? "active" : "")
  })
}

const powerprofilesToggle = Widget.Box({
  class_name: "powerprofiles_toggle",
  children: [
    Widget.Label({
      label: powerprofiles.active_profile
    }),
    powerprofileButton("power-saver"),
    powerprofileButton("balanced"),
    powerprofileButton("performance")
  ]
})

// WiFi
const WifiSelection = Widget.Box({
  class_name: "wifi_selection",
  vertical: true,
  setup: self => self.hook(network.wifi, () => {
    // Step 1: Group networks by SSID
    const groupedNetworks = network.wifi.access_points.reduce((acc, ap) => {
      if (!acc[ap.ssid]) {
        acc[ap.ssid] = [];
      }
      acc[ap.ssid].push(ap);
      return acc;
    }, {});

    // Step 2: Filter out the group that contains the active network
    const filteredNetworks = Object.values(groupedNetworks).filter(group => {
      return !group.some(ap => ap.active);
    }).map(group => {
      // Step 3: From the remaining groups, select the network with the strongest signal
      return group.reduce((bestAp, currentAp) => {
        return currentAp.strength > bestAp.strength ? currentAp : bestAp;
      });
    });

    // Step 4: Sort and map the filtered networks to buttons
    self.children = filteredNetworks
      .sort((a, b) => b.strength - a.strength)
      .slice(0, 10)
      .map(ap => Widget.Box({
        hexpand: true,
        children: [
            Widget.Icon(ap.iconName),
            Widget.Label(ap.ssid || ""),
            Widget.Label({ label: "", hexpand: true }),
            Widget.Button({
              on_clicked: () => {
                Utils.execAsync(`nmcli device wifi connect ${ap.bssid}`)
              },
              child: Widget.Label("Connect"),
            })
          ],
      }));
  }),
});

const wifiMenu = () => {
  const arrowIcon = Widget.Icon("pan-end-symbolic")
   
  const revealer = Widget.Revealer({
    child: WifiSelection,
    reveal_child: false
  })

  return Widget.Box({
    class_name: "wifi_menu",
    vertical: true,
    hexpand: true,
    children: [
      Widget.Box({
        class_name: "wifi_header",
        children: [
          Widget.Icon({ icon: network.wifi.bind("icon-name") }),
          Widget.Label({ 
            label: network.wifi.bind("ssid"),
            hexpand: true,
            hpack: "start",
          }),
          Widget.Button({
            onClicked: () => { Utils.execAsync(['bash', '-c', 'nm-connection-editor']); App.closeWindow("sidebar")},
            child: Widget.Icon("document-edit-symbolic")
          }),
          Widget.Switch({ 
            onActivate: ({ active }) => network.toggleWifi(),
            setup: self => self.active = network.wifi.bind("enabled")
          }),
          Widget.Button({
            onClicked: () => {
              revealer.reveal_child = !revealer.reveal_child
              arrowIcon.icon = revealer.reveal_child ? "pan-down-symbolic" : "pan-end-symbolic"
            },
            child: arrowIcon
          }),
        ],
      }), 
      revealer
    ],
  })
}

export const quickSettings = [
  "applications-system-symbolic",
  Widget.Scrollable({
    class_name: "quick_settings",
    child: Widget.Box({
      vertical: true,
      children: [
        //powerprofilesToggle
        wifiMenu(),
        Widget.Label({
          label: "",
          vexpand: true,
        })
      ]
    })
  })
]