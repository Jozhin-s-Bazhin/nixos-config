{ pkgs, inputs, username, ... }:

{
	# Hide bootloader by default
	boot.loader.timeout = 0;

	# Configure keymap in X11
	services.xserver = {
		xkb.layout = "us";
		xkb.variant = "";
	};
	
	# Enable printing
	services.printing.enable = true;
	services.avahi = {
		enable = true;
		nssmdns4 = true;
		openFirewall = true;
	};
	
	# Auto-upgrade
	/*system.autoUpgrade = {
		enable = true;
		flake = inputs.self.outPath;
		flags = [
			"--update-input"
			"nixpkgs"
			"-L" 
		];
		dates = "03:00";
		randomizedDelaySec = "60min";
		persistent = true;
	};*/
	# I don't want auto-upgrade anywhere now that I think about it
	
	# Pipewire
	security.rtkit.enable = true;
	#hardware.pulseaudio.enable = lib.mkForce false;	# Uncomment when using GNOME
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
		wireplumber.enable = true;
		extraConfig.pipewire-pulse.switch-on-connect."pulse.cmd" = [
			{ cmd = "load-module"; args = "module-switch-on-connect"; }
		];
	};
	users.users.${username}.extraGroups = [ "audio" ];
	
	# Bluetooth
	hardware.bluetooth = {
		enable = true;
		settings.General.Experimental = true;
	};
	services.blueman.enable = true;
}
