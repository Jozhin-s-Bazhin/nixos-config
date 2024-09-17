{ pkgs, username, ... }:
{
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      networkmanagerapplet
      gnome-calculator
      mission-center
      nautilus
      eog
    ];

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        # Nautilus
        "inode/directory" = "org.gnome.Nautilus.desktop";
        
        # Eye of GNOME
        "image/jpg" = "org.gnome.eog.desktop";
        "image/png" = "org.gnome.eog.desktop";
        "image/webp" = "org.gnome.eog.desktop";
      };
    };
  };
}
