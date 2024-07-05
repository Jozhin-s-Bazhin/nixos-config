 

  wayland.windowManager.hyprland = {
    systemd = {
      enableXdgAutostart = true;
      extraCommands = [
        "systemctl --user stop hyprland-session.target"
        "systemctl --user start hyprland-session.target"
	"systemctl --user start xdg-desktop-portal-hyprland"
      ];
    };
  };
}
