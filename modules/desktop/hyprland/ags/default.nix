{ inputs, lib, pkgs, username, configDir, ... }:

{
  #imports = [ ./greetd ];
  services.upower.enable = true;
  home-manager.users.${username} = {
    imports = [ 
      inputs.ags.homeManagerModules.default 
    ];

    wayland.windowManager.hyprland.settings.exec-once = [ "ags -c ${configDir}/modules/desktop/hyprland/ags/config.js" ];

    programs.ags = {
      enable = true;
      extraPackages = with pkgs; [
        gtksourceview
        webkitgtk
        accountsservice
        libnotify
        ( nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; } )
        gnome.gnome-bluetooth
        brightnessctl
      ];
    };
  };
}
