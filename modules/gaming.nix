{ pkgs, lib, config, ... }:
{ 
  options.nixos-config.gaming.enable = lib.mkEnableOption "all my games";
  
  config = lib.mkIf config.nixos-config.gaming.enable {
    # Enable a graphical desktop
    nixos-config.desktop.enable = lib.mkDefault true;

    # Hardware stuff 
    services = { ratbagd.enable = true;	# Mice hardware.openrgb.enable = true; # RGB };

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
    home-manager.users.${config.nixos-config.username}.home.packages = with pkgs; [
			(lutris.override { extraPkgs = pkgs: [
				# War Thunder
				gtk3
				pango
				fontconfig
				vulkan-tools
			];})
			prismlauncher
			crrcsim
			freesweep
		
			# Discord
			vesktop
		];
		
		# Roblox
		services.flatpak.enable = true;


    # Aliases to launch minecraft with gamescope because lutris' gamescope is broken
    programs.zsh.shellAliases = {
      mcgs-laptop = "gamescope -h 1200 -H 1600 -w 1920 -W 2560 -F fsr -f --hdr-enabled --fsr-sharpness 20 -- prismlauncher";
      mcgs-ultrawide = "gamescope -h 1080 -H 1440 -w 2560 -W 3440 -F fsr -f --hdr-enabled --fsr-sharpness 20 -- prismlauncher";
    };
  };
}
