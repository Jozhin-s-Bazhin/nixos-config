const greetd = await Service.import('greetd');

/*async function getUsernames() {
    const output = await Utils.exec("getent passwd | awk -F: '$3 >= 1000 && $3 < 60000 && !/^nixbld/ {print $1}' | grep -v '^nixbld'");
    return output.split('\n').filter(user => user.trim() !== '');
}*/

//const users = await getUsernames();
const users = [ "roman" ];

const userStack = Widget.ListBox({
    css: "background-color: red;",
    setup(self) {
        users.forEach(user => {
            self.add(Widget.Button({
                child: Widget.Label(user),
                onClicked: () => {
                    username = "roman"
                    password.grab_focus();
                },
            }))
        });
    },
});

/*const name = Widget.Entry({
    css: "color: black; background-color: white; border-radius: 10px;",
    placeholder_text: 'Username',
    on_accept: () => password.grab_focus(),
    editable: false, // Making username field non-editable as it's selected from list
});*/

const password = Widget.Entry({
    css: "color: black; background-color: white; border-radius: 10px;",
    placeholder_text: 'Password',
    visibility: false,
    on_accept: () => {
        greetd.login('roman' || '', password.text || '', 'Hyprland')
            .catch(() => {
                password.grab_focus();
            });
    },
});

const loginBox = Widget.Box({
    vertical: true,
    hpack: 'center',
    vpack: 'center',
    hexpand: true,
    vexpand: true,
    children: [
        //name,
        password,
    ],
});

const mainArea = Widget.Box({
    children: [ userStack, loginBox],
});

const win = Widget.Window({
    css: 'background-image: url("/etc/nixos/home/package_config/wallpaper_blurred.png");',
    anchor: ['top', 'left', 'right', 'bottom'],
    child: mainArea,
});

App.config({ windows: [win] });
