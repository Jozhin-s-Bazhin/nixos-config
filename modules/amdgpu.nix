{ pkgs, ...}:

{
  services.xserver.videoDrivers = [ "modesetting" ];
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [ 
      amdvlk 
      rocmPackages.clr.icd
    ];
    extraPackages32 = [
      pkgs.driversi686Linux.amdvlk
    ];
  };
  environment.variables.VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";  # Set RADV as default
  environment.systemPackages = [ pkgs.radeontop ];
}
