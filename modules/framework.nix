{ inputs, pkgs }:
{
  imports = [ inputs.nixos-hardware.nixosModules.framework-16-7040-amd ];

  # Latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Fix autosuspend issue
  boot.kernelParams = [ "usbcore.autosuspend=60" ]; 

  # Hibernation
  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 36*1024;
  }];

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
}
