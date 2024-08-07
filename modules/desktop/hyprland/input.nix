{ config, pkgs, username, ... }:

{
  home-manager.users.${username}.wayland.windowManager.hyprland.settings = {
    input = {
      kb_layout = "us";
      kb_variant = "";
      kb_model ="";
      kb_options ="";
      kb_rules ="";
      follow_mouse = 1;

      touchpad = {
        natural_scroll = true;
        #disable_while_typing = true;
      };
      sensitivity = 0;
    };

    gestures = {
      workspace_swipe = true;
      workspace_swipe_cancel_ratio = "0.1";
    };

    # Custom mouse acceleration
    device = [
      {
        name = "logitech-g502-1";
	accel_profile = "custom 1 0 1 3 7 11 14 16";
      }
    ];
  };
}
