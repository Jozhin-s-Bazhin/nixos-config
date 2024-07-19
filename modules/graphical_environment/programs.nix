{ pkgs, inputs, username, ... }:

{
  home-manager.users.${username} = {
  home.packages = with pkgs; [
    floorp
    nautilus
    eog
    bitwarden
    whatsapp-for-linux
    thunderbird
    spotube
    pavucontrol   
  ];

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
  };
}
