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
        ", Print, exec, grimblast copysave area"

        # Window management
        "SUPER, H, movefocus, l"
        "SUPER SHIFT, H, movewindow, l"
        "SUPER, J, movefocus, d"
        "SUPER SHIFT, J, movewindow, d"
        "SUPER, K, movefocus, u"
        "SUPER SHIFT, K, movewindow, u"
        "SUPER, L, movefocus, r"
        "SUPER SHIFT, L, movewindow, r"

        "SUPER, F11, fullscreen"
        "SUPER, V, togglefloating"

        # Applications
        "SUPER, Tab, exec, ags -t sidebar"
        "SUPER, Return, exec, kitty"
        "SUPER, B, exec, brave"
        "SUPER, C, exec, codium"
	"SUPER, F, exec, nautilus"
	"SUPER, O, exec, obsidian"

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

	# Other
	"WIN, F1, exec, ${pkgs.writeShellScriptBin "gamemode.sh" ''
	  #!/usr/bin/env sh
          HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
          if [ "$HYPRGAMEMODE" = 1 ] ; then
            hyprctl --batch "\
              keyword animations:enabled 0;\
              keyword decoration:drop_shadow 0;\
              keyword decoration:blur:enabled 0;\
              keyword general:gaps_in 0;\
              keyword general:gaps_out 0;\
              keyword general:border_size 1;\
              keyword decoration:rounding 0"
            exit
          fi
          hyprctl reload
	''}/bin/gamemode.sh"
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
        ", XF86MonBrightnessUp, exec, brightnessctl -s set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl -s set 5%- -n 1"
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
      playerctl
    ];
  };
}
