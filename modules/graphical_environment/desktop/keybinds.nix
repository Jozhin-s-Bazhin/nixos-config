{ config, pkgs, username, ... }:

let
  # Workspace bindings
  workspaces_num = [ 1 2 3 4 5 6 7 8 9 ];
  generateWorkspace = num: "SUPER, ${toString num}, exec, pypr workspace ${toString num}";
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

        # Focus
        "SUPER, H, movefocus, l"
        "SUPER SHIFT, H, movewindow, l"
        "SUPER, J, movefocus, d"
        "SUPER SHIFT, J, movewindow, d"
        "SUPER, K, movefocus, u"
        "SUPER SHIFT, K, movewindow, u"
        "SUPER, L, movefocus, r"
        "SUPER SHIFT, L, movewindow, r"

        # Window position
        "SUPER, F11, fullscreen"
        "SUPER, V, togglefloating"

        # Applications
        #"SUPER, Tab, exec, ags -t applauncher"
        "SUPER, Tab, exec, anyrun"
        "SUPER, Return, exec, kitty"
        "SUPER, B, exec, floorp"
        "SUPER, C, exec, codium"

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

      binde = [
        # Audio
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

        # Brightness
        ", XF86MonBrightnessUp, exec, brightnessctl -s set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl -s set 5%- -n 1"
      ];

      bindl = [
        ", switch:on:Lid Switch, exec, systemctl suspend"
      ];
    };
    home.packages = with pkgs; [
      brightnessctl
      wl-clipboard-rs
      cliphist
      grimblast
      anyrun
    ];
  };
}
