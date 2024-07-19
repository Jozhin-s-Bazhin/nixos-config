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

  # Nautilus and floorp
  home.packages = with pkgs; [ floorp nautilus eog ];
  xdg.mimeApps.defaultApplications = {
    # Nautilus
    "inode/directory" = "nautilus.desktop";

    # Floorp
    "text/html" = "floorp.desktop";
    "x-scheme-handler/http" = "floorp.desktop";
    "x-scheme-handler/https" = "floorp.desktop";
    "x-scheme-handler/about" = "floorp.desktop";
    "x-scheme-handler/unknown" = "floorp.desktop";
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

  # Floorp webapps
  system.activationScripts.floorp.text = ''
    ln -sfn ${pkgs.floorp}/bin/floorp /usr/bin/floorp 
  '';
}
