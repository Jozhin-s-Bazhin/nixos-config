{ inputs, pkgs, username, ... }:
{
  imports = [ inputs.nixos-hardware.nixosModules.framework-16-7040-amd ];

  # Latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Hibernation & autosuspend issue
  boot.kernelParams = [ "usbcore.autosuspend=60" "resume_offset=53248" ]; 
  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 36*1024;
  }];
  boot.resumeDevice = "/dev/nvme0n1p2";

  # Firmware updates
  services.fwupd.enable = true; 
  environment.systemPackages = [ pkgs.gnome-firmware ];

  # Palm rejection
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Framework Laptop 16 Keyboard Module]
    MatchName=Framework Laptop 16 Keyboard Module*
    MatchUdevType=keyboard
    MatchDMIModalias=dmi:*svnFramework:pnLaptop16*
    AttrKeyboardIntegration=internal
  '';

  # Auto-brightness with wluma
  home-manager.users.${username} = {
    xdg.configFile."wluma/config.toml".text = ''
      [als.iio]
      path = "/sys/bus/iio/devices"
      thresholds = { 0 = "night", 20 = "dark", 80 = "dim", 250 = "normal", 500 = "bright", 800 = "outdoors" }
      
      [[output.backlight]]
      name = "eDP-2"
      path = "/sys/class/backlight/amdgpu_bl2"
      capturer = "none"
  '';
    home.packages = [ pkgs.wluma ];
  };
}
