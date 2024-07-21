{ pkgs, username, ... }:
{
  environment.systemPackages = [ pkgs.virtiofsd ];
  programs.virt-manager.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      ovmf = {
        enable = true; 
	packages = [pkgs.OVMFFull.fd];
      };
      swtpm.enable = true; 
    };
  };
  users.users.${username}.extraGroups = [ "libvirtd" "kvm" "qemu-libvirtd" ];
}
