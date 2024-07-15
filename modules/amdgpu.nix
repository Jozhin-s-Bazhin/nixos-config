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
  #environment.variables.AMD_VULKAN_ICD = "RADV";
  environment.systemPackages = [ pkgs.radeontop ];
}
