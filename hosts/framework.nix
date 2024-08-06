{ inputs, pkgs, username, ... }:
{
  imports = [ inputs.nixos-hardware.nixosModules.framework-16-7040-amd ];

  # Latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Hibernation & autosuspend issue
  boot.kernelParams = [ "usbcore.autosuspend=60" "resume_offset=53248" "nvme.noacpi=1" ]; 
  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 36*1024;
  }];
  boot.resumeDevice = "/dev/nvme0n1p2";

  # Firmware updates
  services.fwupd.enable = true; 
  environment.systemPackages = [ pkgs.gnome-firmware ];

  # Auto-brightness with wluma
  home-manager.users.${username} = {
    xdg.configFile = {
      "wluma/config.toml".text = ''
        [als.iio]
        path = "/sys/bus/iio/devices"
        thresholds = { 0 = "night", 20 = "dark", 80 = "dim", 250 = "normal", 500 = "bright", 800 = "outdoors" }
        
        [[output.backlight]]
        name = "eDP-2"
        path = "/sys/class/backlight/amdgpu_bl2"
        capturer = "none"
      '';
    };
    systemd.user.services.wluma = {
      Unit = {
        Description = "Adjusting screen brightness based on screen contents and amount of ambient light";
	PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.wluma}/bin/wluma";
	Restart = "always";
        EnvironmentFile = "-%E/wluma/service.conf";
	PrivateNetwork = "true";
	PrivateMounts = "false";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };

  # Disable keyboard wake-up
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0012", ATTR{power/wakeup}="disabled"
  '';
}
