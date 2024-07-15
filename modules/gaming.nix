{ pkgs, username, config, ... }:
{ # Hardware stuff services = {
    ratbagd.enable = true;  # Mice
    hardware.openrgb.enable = true; # RGB
  };

  # Android emulation
  virtualisation.waydroid.enable = true;
  
  # Steam
  programs.steam = {
    enable = true;
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


  
      "${pkgs.writeShellScriptBin "prismlauncher.sh" ''
        #!/run/sw/current-system/bin/bash
        export VK_ICD_FILENAMES=/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json  # AMD driver bs (this is worse than nvidia)
        gamescope -w 0 -h 0 -f --fsr -- prismlauncher
      ''}/bin/prismlauncher.sh";
}
