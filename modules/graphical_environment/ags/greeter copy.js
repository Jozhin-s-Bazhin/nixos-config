const greetd = await Service.import('greetd');

const users = Utils.exec("getent passwd | awk -F: '$3 >= 1000 && $3 < 60000 && !/^nixbld/ {print $1}' | grep -v '^nixbld'")

const name = Widget.Entry({
    css: "color: black; background-color: white; border-radius: 10px;",
    placeholder_text: 'Username',
    on_accept: () => password.grab_focus(),
})

const password = Widget.Entry({
    css: "color: black; background-color: white; border-radius: 10px;",
    placeholder_text: 'Password',
    visibility: false,
    on_accept: () => {
        greetd.login("roman" || '', password.text || '', 'Hyprland')
            .catch(() => password.text = "", name.grab_focus())
    },
})

const stack = Widget.ListBox({
    setup(self) {
        self.add(Widget.Button({
            child: Widget.Label("roman"),
            onClicked: () => password.grab_focus(),
        }))
    },
})

const win = Widget.Window({
    css: 'background-image: url("/etc/nixos/home/package_config/wallpaper_blurred.png");',
    anchor: ['top', 'left', 'right', 'bottom'],
    child: Widget.Box({
        vertical: true,
        hpack: 'center',
        vpack: 'center',
        hexpand: true,
        vexpand: true,
        children: [
            name,
            password,
        ],const greetd = await Service.import('greetd');

        const users = Utils.exec("getent passwd | awk -F: '$3 >= 1000 && $3 < 60000 && !/^nixbld/ {print $1}' | grep -v '^nixbld'")
        
        const name = Widget.Entry({
            css: "color: black; background-color: white; border-radius: 10px;",
            placeholder_text: 'Username',
            on_accept: () => password.grab_focus(),
        })
        
        const password = Widget.Entry({
            css: "color: black; background-color: white; border-radius: 10px;",
            placeholder_text: 'Password',
            visibility: false,
            on_accept: () => {
                greetd.login("roman" || '', password.text || '', 'Hyprland')
                    .catch(() => password.text = "", name.grab_focus())
            },
        })
        
        const stack = Widget.ListBox({
            setup(self) {
                self.add(Widget.Button({
                    child: Widget.Label("roman"),
                    onClicked: () => password.grab_focus(),
                }))
            },
        })
        
        const win = Widget.Window({
            css: 'background-image: url("/etc/nixos/home/package_config/wallpaper_blurred.png");',
            anchor: ['top', 'left', 'right', 'bottom'],
            child: Widget.Box({
                vertical: true,
                hpack: 'center',
                vpack: 'center',
                hexpand: true,
                vexpand: true,
                children: [
                    name,
                    password,
                ],
            }),
        })
        
        App.config({ windows: [win] })
        
    }),
})

App.config({ windows: [win] })
