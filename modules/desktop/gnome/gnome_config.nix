{ pkgs, username, ... }:
{
  # Enable gnome
  services.xserver = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # Remove some default apps
  environment.gnome.excludePackages = (with pkgs; [
    # for packages that are pkgs.*
    gnome-tour
    gnome-connections
    evince # document viewer
    epiphany # web browser
    geary # email reader 
  ]);

  home-manager.users.${username}.dconf = {
    enable = true;
  };
  
  # Other stuff from the wiki
  services.udev.packages = [ pkgs.gnome-settings-daemon ];
  services.dbus.packages = with pkgs; [ gnome2.GConf ];

  # Disable pulseaudio
  hardware.pulseaudio.enable = false;
}
