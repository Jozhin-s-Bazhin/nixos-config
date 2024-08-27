{ config, pkgs, username, ... }:
let 
  # I hope you have syntax highlighting
  # args: workspace/movetoworkspace <workspaceid>
  workspaceSwitcher = pkgs.writers.writePython3Bin "workspaceSwitcher" {} ''
    from subprocess import run
    from json import loads
    from sys import argv, exit


    def hyprctl_json(message):
        output = run(f"hyprctl -j {message}", shell=True,
                     capture_output=True, encoding="utf-8")
        json = loads(output.stdout)
        return json


    def get_workspaces():
        workspaces = [
          workspace["id"] for workspace in hyprctl_json("workspaces")
          if workspace["id"] > 0
        ]
        workspaces.sort()
        return workspaces


    def get_currentworkspace():
        monitors = hyprctl_json("monitors")
        for monitor in monitors:
            if monitor["focused"]:
                return monitor["activeWorkspace"]["id"]


    def get_target_workspace(workspaceid):
        workspaces = get_workspaces()

        if workspaceid == "new":
            return workspaces[-1] + 1

        elif "+" in workspaceid:
            currentworkspace = get_currentworkspace()

            for i in range(len(workspaces)):
                if workspaces[i] == currentworkspace:
                    if i + 1 >= len(workspaces):
                        return workspaces[i] + 1
                    else:
                        return workspaces[i + 1]

        elif "-" in workspaceid:
            currentworkspace = get_currentworkspace()

            for i in range(len(workspaces)):
                if workspaces[i] == currentworkspace:
                    if workspaces[i] == 1:
                        return "No target workspace"
                    elif i == 0:
                        return workspaces[i] - 1
                    else:
                        return workspaces[i - 1]

        else:
            workspaceid = int(workspaceid)
            if workspaceid > len(workspaces):
                target = workspaces[-1] + 1
            else:
                target = workspaces[workspaceid - 1]
            return target


    target = get_target_workspace(argv[2])
    if target == "No target workspace":
        exit()

    if argv[1] == "workspace":
        run(["hyprctl", "dispatch", "workspace", f"{target}"])
    elif argv[1] == "movetoworkspace":
        run(["hyprctl", "dispatch", "movetoworkspace", f"{target}"])
  '';

  # Workspace bindings
  workspaces_num = [ 1 2 3 4 5 6 7 8 9 ]; generateWorkspace = num: "SUPER, ${toString num}, exec, ${workspaceSwitcher}/bin/workspaceSwitcher workspace ${toString num}";
  generateMoveToWorkspace = num: "SUPER SHIFT, ${toString num}, exec, ${workspaceSwitcher}/bin/workspaceSwitcher movetoworkspace ${toString num}";
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
        "SUPER, mouse_down, exec, ${workspaceSwitcher}/bin/workspaceSwitcher workspace -1"
        "SUPER SHIFT, mouse_down, exec, ${workspaceSwitcher}/bin/workspaceSwitcher movetoworkspace -1"
        "SUPER, mouse_up, exec, ${workspaceSwitcher}/bin/workspaceSwitcher workspace +1"
        "SUPER SHIFT, mouse_up, exec, ${workspaceSwitcher}/bin/workspaceSwitcher movetoworkspace +1"

        # Workspace switching with arrow keys
        "SUPER, left, exec, ${workspaceSwitcher}/bin/workspaceSwitcher workspace -1"
        "SUPER SHIFT, left, exec, ${workspaceSwitcher}/bin/workspaceSwitcher movetoworkspace -1"
        "SUPER, right, exec, ${workspaceSwitcher}/bin/workspaceSwitcher workspace +1"
        "SUPER SHIFT, right, exec, ${workspaceSwitcher}/bin/workspaceSwitcher movetoworkspace +1"

        # Other
        "WIN, F1, exec, ${pkgs.writers.writeBashBin "gamemode.sh" ''
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
        ", XF86MonBrightnessUp, exec, brightnessctl --exponent=2.2 s 3%+"
        ", XF86MonBrightnessDown, exec, brightnessctl --exponent=2.2 s 3%-"
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
