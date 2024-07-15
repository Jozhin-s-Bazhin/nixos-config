{ pkgs, ...}:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    /*extraPackages = with pkgs; [ 
      amdvlk 
    ];
    extraPackages32 = [
      pkgs.driversi686Linux.amdvlk
    ];*/
  };
  environment.systemPackages = [ pkgs.radeontop ];
}
