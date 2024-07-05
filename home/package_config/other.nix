{ lib, config, pkgs, ... }:

{
  xdg.configFile."hypr/pyprland.toml".text = ''
    [pyprland]
    plugins = [
      "external:better_workspaces",
      "external:ags_tools"
    ]
    plugins_paths = [
      "/etc/nixos/home/scripts/pypr"
    ]
  '';
}
