{
  config,
  lib,
  ...
}:

{
  config = lib.mkIf config.nixos-config.desktop.hyprland.enable {
    home-manager.users.${config.nixos-config.username}.wayland.windowManager.hyprland.settings = {
      input = {
        kb_layout = config.services.xserver.xkb.layout;
        kb_variant = config.services.xserver.xkb.variant;
        kb_options = config.services.xserver.xkb.options;
        follow_mouse = 1;

        touchpad = {
          natural_scroll = true;
          scroll_factor = "0.5";
          disable_while_typing = false;
        };
        sensitivity = 0;
        numlock_by_default = true;
      };

      general.snap.enabled = true;

      gestures = {
        workspace_swipe = true;
        workspace_swipe_cancel_ratio = "0.1";
      };

      misc = {
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
      };
    };
  };
}
