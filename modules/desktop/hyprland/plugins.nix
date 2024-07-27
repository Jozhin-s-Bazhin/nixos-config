{ inputs, username, ... }:
{
  home-manager.users.${username}.wayland.windowManager.hyprland = {
    plugins = [
      inputs.hyprscroller.packages."x86_64-linux".hyprscroller
    ];

    settings = {
      plugin = {
        scroller = {
	  column_default_width = "one";
	  focus_wrap = false;
	  column_widths = "onehalf onethird onefourth one";
	};
      };
    };
  };
}
