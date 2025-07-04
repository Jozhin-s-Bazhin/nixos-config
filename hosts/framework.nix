{
  inputs,
  pkgs,
  config,
  ...
}:
{
  imports = [ inputs.nixos-hardware.nixosModules.framework-16-7040-amd ];

  # Specialisations
  /*
    specialisation = {
      plasma.configuration = {
        config.nixos-config.desktop = {
          plasma.enable = true;
          hyprland.enable = false;
        };
      };
      qemu.configuration = {
        config.nixos-config.virtualisation.qemu.enable = true;
      };
      gnome.configuration = {
        config.nixos-config.desktop = {
          gnome.enable = true;
          hyprland.enable = false;
        };
      };
    };
  */

  # Custom options
  nixos-config = {
    laptop.enable = true;
    amdgpu.enable = true;
    desktop = {
      enable = true;
      desktop = "plasma";
    };
    development.enable = true;
    gaming.enable = true;
    media.enable = true;
    office.enable = true;
    cad.enable = true;
    username = "roman";
  };

  # Latest kernel
  #boot.kernelPackages = pkgs.linuxPackages_latest;

  # Kernel parameters
  boot.kernelParams = [
    "usbcore.autosuspend=60" # Fix usb autosuspend
    "resume_offset=53248" # For hibernation
  ];
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 36 * 1024;
    }
  ];
  boot.resumeDevice = "/dev/disk/by-id/nvme-TEAM_TM8FPW001T_TPBF2401110080400617-part2";

  # Firmware updates
  services.fwupd.enable = true;
  environment.systemPackages = [ pkgs.gnome-firmware ];

  # Hyprland
  home-manager.users.${config.nixos-config.username} = {
    wayland.windowManager.hyprland.settings.monitor = [
      "eDP-2, preferred, 0x0, 1.6"
    ];
  };
  environment.variables."AQ_NO_MODIFIERS" = 1;

  # Ollama ROCM integration
  services.ollama.rocmOverrideGfx = "11.0.2";

  # udev Rules
  services.udev.extraRules = ''
    # Disable keyboard wake-up
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0012", ATTR{power/wakeup}="disabled"

    # Set power-saver profile on battery
    SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${pkgs.power-profiles-daemon}/bin/powerprofilesctl set power-saver"

    # Set performance profile on AC power
    SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${pkgs.power-profiles-daemon}/bin/powerprofilesctl set performance"
  '';

  # Enable qmk
  hardware.keyboard.qmk.enable = true;

  # Add russian phonetic keyboard layout
  services.xserver.xkb = {
    layout = "us,ru";
    variant = ",phonetic";
  };

  # Fix network
  networking.networkmanager.wifi.macAddress = "random";
}
