{
  pkgs,
  lib,
  config,
  ...
}:

{
  options.nixos-config.amdgpu.enable = lib.mkEnableOption "everything needed for a modern AMD GPU";

  config = lib.mkIf config.nixos-config.amdgpu.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = [ pkgs.rocmPackages.clr.icd ];
    };
    hardware.amdgpu.opencl.enable = true;
    environment.systemPackages = [ pkgs.radeontop ];
    services.ollama = {
      acceleration = "rocm";
      package = pkgs.ollama-rocm;
    };
  };
}
