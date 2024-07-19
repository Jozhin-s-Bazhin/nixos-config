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
        enable_audio_bell = "no";
        hide_window_decorations = "yes";
	linux_display_server = "wayland";
      };
    };

  # Floorp
  home.packages = [ pkgs.floorp ];

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
  system.activationScripts.floorp.text = ''
    ln -sfn ${pkgs.floorp}/bin/floorp /usr/bin/floorp 
  '';
}
