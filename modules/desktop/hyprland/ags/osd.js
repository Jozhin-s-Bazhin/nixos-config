import brightness from './services/brightness.js';
const audio = await Service.import('audio')

const DELAY = 2000

export function VolumeOsd() {
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

  const window = Widget.Window({
    name: "VolumeOsd",
    class_name: "volume_osd",
    anchor: ["bottom"],
    child: Widget.Box({
      children: [
        Widget.Icon({
          icon: Utils.watch(getIcon(), audio.speaker, getIcon),
          size: 20
        }),

        Widget.Slider({
          on_change: ({ value }) => audio['speaker'].volume = value,
          value: audio['speaker'].bind('volume'),
          draw_value: false,
          hexpand: true,
          min: 0,
          max: 1.50,
        })
      ],
    }),
    visible: false
  })

  let count = 0;
  Utils.watch(false, audio, "changed", () => {
    count++
    window.visible = true
    Utils.timeout(DELAY, () => {
      count--
      if (count === 0) { window.visible = false }
    })
  })

  return window
}

export function BrightnessOsd() {
  const window = Widget.Window({
    name: "BrightnessOsd",
    class_name: "brightness_osd",
    anchor: ["bottom"],
    child: Widget.Box({
      children: [
        Widget.Icon ({
          icon: brightness.bind("screen-value").as(b => 
            b <= 33 ? "display-brightness-symbolic" :
            b <= 66 ? "display-brightness-symbolic" :
            "display-brightness-symbolic"
          ),
          size: 20
        }),
        Widget.Slider({
          on_change: self => brightness.screen_value = self.value,
          value: brightness.bind('screen-value'),
          draw_value: false,
          hexpand: true,
          
        })
      ],
    }),
    visible: false
  })

  let count = 0;
  Utils.watch(false, brightness, "changed", () => {
    count++
    window.visible = true
    Utils.timeout(DELAY, () => {
      count--
      if (count === 0) { window.visible = false }
    })
  })

  return window
}