{ inputs, lib, pkgs, config, ... }:

{
  config = lib.mkIf config.nixos-config.desktop.hyprland.enable {
    services.upower.enable = true;
    home-manager.users.${config.nixos-config.username} = {
      imports = [ 
        inputs.ags.homeManagerModules.default 
      ];

      programs.ags = {
        enable = true;
        extraPackages = with pkgs; [
          gtksourceview
          webkitgtk
          accountsservice
          libnotify
          nerd-fonts.symbols-only
          gnome-bluetooth
          brightnessctl
          networkmanagerapplet
          bash
          killall
          wluma
        ];
      };

      wayland.windowManager.hyprland.settings.exec-once = [ "${inputs.ags.packages.${pkgs.system}.default}/bin/ags -c ${config.nixos-config.configDir}/modules/desktop/hyprland/ags/config.js" ];
    };
  };
}
