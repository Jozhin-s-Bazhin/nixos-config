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
  };
}
