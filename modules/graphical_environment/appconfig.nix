{ pkgs, username, config, ... }:

{
  home-manager.users.${username} = {
  # Kitty
    programs.kitty = {
      enable = true;
      settings = {
        confirm_os_window_close = "0";
        window_padding_width = "3";
	font_family = config.stylix.fonts.monospace.name;
        font_size = "12";
	symbol_map = "U+e0b4 Symbols Nerd Font Mono";
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

  # Floorp
  #environment.pathsToLink = [ "/usr/bin" ];
  system.activationScripts.floorp.text = ''
    ln -sfn ${pkgs.floorp}/bin/floorp /usr/bin/floorp 
  '';
}
