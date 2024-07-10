{ username, ... }:

{
  home-manager.users.${username} = {
  # Kitty
    programs.kitty = {
      enable = true;
      settings = {
        #background = "#${colors.nixToHex colors.background_darker}";
        #background_opacity = toString colors.opacity;
        confirm_os_window_close = "0";
        window_padding_width = "3";
        font_family = "UbuntuMono Nerd Font";
        font_size = "13.0";
        enable_audio_bell = "no";
        hide_window_decorations = "yes";
	linux_display_server = "wayland";
      };
    };

  # KDEConnect
    services.kdeconnect = {
      enable = true;
      indicator = true;
    }; 
  }; 
  services.dbus.enable = true;
  networking.firewall = {
    allowedTCPPorts = [ 1714 1715 ];
    allowedUDPPorts = [ 1714 1715 1716 ];
  };
}
