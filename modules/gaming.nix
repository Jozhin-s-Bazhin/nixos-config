{ pkgs, username, ... }:

{
  # Hardware stuff
  services = {
    ratbagd.enable = true;  # Mice
    hardware.openrgb.enable = true; # RGB
  };
  
  # Steam
  programs.steam = {
    #enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # Gamescope
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };
  
  # Games
  home-manager.users.${username}.home.packages = with pkgs; [
    (lutris.override { extraPkgs = pkgs: [
      # War Thunder
      gtk3
      pango
      fontconfig
    ];})
    prismlauncher
    crrcsim
    freesweep
    
    # Discord
    vesktop
  ];
}
