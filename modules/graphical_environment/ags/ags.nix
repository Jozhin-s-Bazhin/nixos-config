#             _____   _____
#     /\     / ____| / ____|
#    /  \   | |  __  | (___  
#   / /\ \  | | |_ | \___  \ 
#  / ____ \ | |__| |  ____) |
# /_/    \_\ \_____| |_____/ 
                        
# By Roman Bezroutchko

{ inputs, lib, pkgs, username, ... }:

{
  services.upower.enable = true;
  home-manager.users.${username} = {
    # add the home manager module
    imports = [ inputs.ags.homeManagerModules.default ];

    programs.ags = {
      enable = true;

      # additional packages to add to gjs's runtime
      extraPackages = with pkgs; [
        gtksourceview
        webkitgtk
        accountsservice
        libnotify
        nerdfonts
      ];
    };

    home.file.".config/ags/config.js".source = ./config.js;
    home.file.".config/ags/colors.css".text = ''
      @define-color foreground #ffffff;
      @define-color accent #066cfa;
      @define-color background #252525;
      @define-color background-selected #404040;
      @define-color background-darker rgba(0, 0, 0, 1);
    '';
    home.file.".config/ags/style.css".source = ./style.css;

    # Bar
    home.file.".config/ags/bar.js".source = ./bar.js;

    # App Launcher
    home.file.".config/ags/applauncher.js".source = ./applauncher.js;

    # Notifications
    home.file.".config/ags/notifications.js".source = ./notifications.js;
  };
}