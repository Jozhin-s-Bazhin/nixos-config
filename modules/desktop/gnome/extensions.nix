{ pkgs, username, ... }:
{
  environment.systemPackages = with pkgs.gnomeExtensions; [
    blur-my-shell
    forge
    gsconnect
  ];

  home-manager.users.${username}.dconf.settings."org/gnome/shell" = {
    disable-user-extensions = false;
    enabled-extensions = with pkgs.gnomeExtensions; [
      blur-my-shell.extensionUuid
      forge.extensionUuid
      gsconnect.extensionUuid
    ];
  };
}
