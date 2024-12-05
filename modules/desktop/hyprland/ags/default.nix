{ inputs, lib, pkgs, username, configDir, ... }:

{


  #imports = [ ./greetd ];
  services.upower.enable = true;
  home-manager.users.${username} = {
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

    wayland.windowManager.hyprland.settings.exec-once = [ "systemctl --user start startAgs.service" ];

    home.activation.reloadAgs = ''
      ${pkgs.systemd}/bin/systemctl --user restart startAgs.service
    '';

    systemd.user.enable = true;
    systemd.user.services.startAgs = {
      Unit = {
        Description = "Start AGS with Hyprland";  # This is in a service so it can be restarted on rebuild
	After = [ "graphical.target" ];
      };

      Service = {
	ExecStart = "${pkgs.writeShellScriptBin "restartAgs" ''
	  #!/usr/bin/env bash

          ${inputs.ags.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/ags -q
          ${inputs.ags.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/ags -c ${configDir}/modules/desktop/hyprland/ags/config.js
	''}/bin/restartAgs";
      };

      Install.WantedBy = [ "graphical.target" ];
    };
  };
}
