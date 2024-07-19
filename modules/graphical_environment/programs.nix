{ pkgs, inputs, username, ... }:

{
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      floorp
      nautilus
      gnome-photos
      bitwarden
      whatsapp-for-linux
      thunderbird
      spotube
      pavucontrol   
      pinta
    ];

    xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Nautilus
      "inode/directory" = "org.gnome.Nautilus.desktop";
      
      # GNOME image viewer
      "image/jpg" = "org.gnome.Photos.desktop";
      "image/png" = "org.gnome.Photos.desktop";
      "image/webp" = "org.gnome.Photos.desktop";

      # Floorp
      "text/html" = "floorp.desktop";
      "x-scheme-handler/http" = "floorp.desktop";
      "x-scheme-handler/https" = "floorp.desktop";
      "x-scheme-handler/about" = "floorp.desktop";
      "x-scheme-handler/unknown" = "floorp.desktop";
    };
    };
  };
}
