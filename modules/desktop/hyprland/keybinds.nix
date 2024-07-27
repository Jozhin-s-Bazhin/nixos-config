{ config, pkgs, username, ... }:
let # Workspace bindings
  workspaces_num = [ 1 2 3 4 5 6 7 8 9 ]; generateWorkspace = num: "SUPER, ${toString num}, exec, pypr workspace ${toString num}";
  generateMoveToWorkspace = num: "SUPER SHIFT, ${toString num}, exec, pypr movetoworkspace ${toString num}";
  workspaceBindings = (map generateWorkspace(workspaces_num)) ++ (map generateMoveToWorkspace(workspaces_num));
in 
{
  home-manager.users.${username} = {
    wayland.windowManager.hyprland.settings = {
      bind = [
        # Controls
        "SUPER, Space, killactive"
        #"SUPER, grave, overview:toggle, all"
        ", Print, exec, grimblast copysave area"

        # Window management
        "SUPER, H, scroller:movefocus, l"
        "SUPER SHIFT, H, scroller:movewindow, l"
        "SUPER, J, scroller:movefocus, d"
        "SUPER SHIFT, J, scroller:movewindow, d"
        "SUPER, K, scroller:movefocus, u"
        "SUPER SHIFT, K, scroller:movewindow, u"
        "SUPER, L, scroller:movefocus, r"
        "SUPER SHIFT, L, scroller:movewindow, r"

        "SUPER, home, scroller:movefocus, begin"
        "SUPER SHIFT, home, scroller:movewindow, begin"
        "SUPER, end, scroller:movefocus, end"
        "SUPER SHIFT, end, scroller:movewindow, end"

	"SUPER, minus, scroller:cyclesize, prev"
	"SUPER, equal, scroller:cyclesize, next"
	"SUPER, grave, scroller:toggleoverview"

        "SUPER, F11, fullscreen"
        "SUPER, V, togglefloating"

        # Applications
        #"SUPER, Tab, exec, ags -t applauncher"
        "SUPER, Tab, exec, anyrun"
        "SUPER, Return, exec, kitty"
        "SUPER, B, exec, brave"
        "SUPER, C, exec, codium"
	"SUPER, F, exec, nautilus"

        # Scratchpad
        "SUPER, Backspace, togglespecialworkspace"
        "SUPER SHIFT, Backspace, movetoworkspace, special"

        # Workspace switching with mouse wheel
        "SUPER, mouse_down, exec, pypr workspace -1"
        "SUPER SHIFT, mouse_down, exec, pypr movetoworkspace -1"
        "SUPER, mouse_up, exec, pypr workspace +1"
        "SUPER SHIFT, mouse_up, exec, pypr movetoworkspace +1"

        # Workspace switching with arrow keys
        "SUPER, left, exec, pypr workspace -1"
        "SUPER SHIFT, left, exec, pypr movetoworkspace -1"
        "SUPER, right, exec, pypr workspace +1"
        "SUPER SHIFT, right, exec, pypr movetoworkspace +1"
      ] 
      ++
      workspaceBindings;

      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];

      bindel = [
        # Audio
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"

        # Brightness
        ", XF86MonBrightnessUp, exec, brightnessctl -s set 1%+"
        ", XF86MonBrightnessDown, exec, brightnessctl -s set 1%- -n 1"
      ];

      bindl = [
        # Audio and player control
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
	", XF86AudioPlay, exec, playerctl play-pause"
	", XF86AudioPrev, exec, playerctl previous"
	", XF86AudioNext, exec, playerctl next"
      ];
    };
    home.packages = with pkgs; [
      brightnessctl
      wl-clipboard-rs
      cliphist
      grimblast
      anyrun
      playerctl
    ];
  };
}
