{
  pkgs,
  config,
  lib,
  ...
}:
{
  options.nixos-config.virtualisation.qemu.enable =
    lib.mkEnableOption "virtualisation trough qemu and virt-manager";

  config = lib.mkIf config.nixos-config.virtualisation.qemu.enable {
    environment.systemPackages = [ pkgs.virtiofsd ];
    programs.virt-manager.enable = true;
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        ovmf = {
          enable = true;
          packages = [ pkgs.OVMFFull.fd ];
        };
        swtpm.enable = true;
      };
    };
    users.users.${config.nixos-config.username}.extraGroups = [
      "libvirtd"
      "kvm"
      "qemu-libvirtd"
    ];
    networking.firewall.trustedInterfaces = [ "" ];
  };
}
