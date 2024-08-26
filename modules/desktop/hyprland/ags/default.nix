{ inputs, lib, pkgs, username, configDir, ... }:

{
  # Reload ags when system is rebuilt
  system.activationScripts.reloadAgs = ''
    ${inputs.ags.packages.${builtins.currentSystem}.default}/bin/ags -q
    ${inputs.ags.packages.${builtins.currentSystem}.default} ags -c ${configDir}/modules/desktop/hyprland/ags/config.js
  '';

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
