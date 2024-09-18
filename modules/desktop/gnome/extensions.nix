{ pkgs, username, ... }:
{
  environment.systemPackages = with pkgs.gnomeExtensions; [
    blur-my-shell
    forge
    gsconnect
    dash-to-panel
    switch-workspaces-on-active-monitor
    open-browser-tabs-on-active-workspace
  ];

  home-manager.users.${username}.dconf.settings."org/gnome/shell" = {
    disable-user-extensions = false;
    enabled-extensions = with pkgs.gnomeExtensions; [
      blur-my-shell.extensionUuid
      forge.extensionUuid
      gsconnect.extensionUuid
      dash-to-panel.extensionUuid
      switch-workspaces-on-active-monitor.extensionUuid
      open-browser-tabs-on-active-workspace.extensionUuid
    ];
  };
}
