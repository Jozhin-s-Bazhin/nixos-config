{ inputs, lib, pkgs, username, ... }:

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
	( nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; } )
      ];
    };
  };
}
