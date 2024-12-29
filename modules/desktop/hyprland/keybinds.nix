{ config, pkgs, lib, ... }:
let 
	hyprnome = "${pkgs.hyprnome}/bin/hyprnome";
	workspaceSwitcher = pkgs.writers.writePython3Bin "workspaceSwitcher" {
		flakeIgnore = [ "E265" "E999" "W191" "E117" "W292" "W293" "E101" "E128" ];  # Why is this a thing
	} 
	''
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
  config = lib.mkIf config.nixos-config.desktop.hyprland.enable {
    home-manager.users.${config.nixos-config.username} = {
      wayland.windowManager.hyprland.settings = {
        bind = [
          # Controls
          "SUPER, Space, killactive"
          ", Print, exec, ${pkgs.grimblast}/bin/grimblast copysave area"
					"SUPER, Escape, exec, ${pkgs.systemd}/bin/loginctl lock-session"

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
          "SUPER, B, exec, zen"
          "SUPER, C, exec, codium"
          "SUPER, F, exec, nautilus"
          "SUPER, O, exec, obsidian"

          # Scratchpad
          "SUPER, Backspace, togglespecialworkspace"
          "SUPER SHIFT, Backspace, movetoworkspace, special"

          # Workspace switching with mouse wheel
          "SUPER, mouse_down, exec, ${hyprnome} --previous"
          "SUPER SHIFT, mouse_down, exec, ${hyprnome} --previous --move"
          "SUPER, mouse_up, exec, ${hyprnome}"
          "SUPER SHIFT, mouse_up, exec, ${hyprnome} --move"
					"SUPER, mouse:274, overview:toggle"

          # Workspace switching with arrow keys
          "SUPER, left, exec, ${hyprnome} --previous"
          "SUPER SHIFT, left, exec, ${hyprnome} --previous --move"

          "SUPER, right, exec, ${hyprnome}"
          "SUPER SHIFT, right, exec, ${hyprnome} --move"

          # Game mode
          "SUPER, F1, exec, ${pkgs.writers.writeBashBin "gamemode.sh" ''
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

          # Disable workspace swipe 
          "SUPER, F2, exec, ${pkgs.writers.writeBashBin "disableWorkspaceSwipe.sh" ''
            swipe_on=$(hyprctl getoption gestures:workspace_swipe | awk -F': ' '/: [01]$/ {print $2}')

            if [ $swipe_on -eq 0 ]; then
              hyprctl keyword gestures:workspace_swipe true
            else
              hyprctl keyword gestures:workspace_swipe false
            fi
          ''}/bin/disableWorkspaceSwipe.sh"
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
          ", XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl --exponent=2.2 s 3%+"
          ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl --exponent=2.2 s 3%-"
        ];

        bindl = [
          # Audio and player control
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
          ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
          ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
        ];
      };
    };
  };
}
