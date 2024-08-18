{ pkgs, inputs, username, ... }:

{
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      nautilus
      gnome-photos
      gnome-calculator
      mission-center
      bitwarden
      whatsapp-for-linux
      thunderbird
      spotube
      pavucontrol   
      obsidian
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
      };
    };
  };
  programs.dconf.enable = true;
}
