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
        font_size = "12.0";
        enable_audio_bell = "no";
        hide_window_decorations = "yes";
	linux_display_server = "wayland";
        symbol_map = "U+e000-U+e00a,U+ea60-U+ebeb,U+e0a0-U+e0c8,U+e0ca,U+e0cc-U+e0d4,U+e200-U+e2a9,U+e300-U+e3e3,U+e5fa-U+e6b1,U+e700-U+e7c5,U+f000-U+f2e0,U+f300-U+f372,U+f400-U+f532,U+f0001-U+f1af0 Symbols Nerd Font Mono";
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
