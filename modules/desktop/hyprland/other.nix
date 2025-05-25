{
  pkgs,
  config,
  lib,
  ...
}:

{
  config = lib.mkIf config.nixos-config.desktop.hyprland.enable {
    home-manager.users.${config.nixos-config.username} = {
      wayland.windowManager.hyprland.settings = {
        monitor = [ ", preferred, auto, 1, cm, auto" ];

        windowrulev2 = [
          # XWaylandvideobridge
          "opacity 0.0 override 0.0 override, class:^(xwaylandvideobridge)$"
          "noanim, class:^(xwaylandvideobridge)$"
          "noinitialfocus, class:^(xwaylandvideobridge)$"
          "maxsize 1 1, class:^(xwaylandvideobridge)$"
          "noblur, class:^(xwaylandvideobridge)$"

          # LibreOffice
          "suppressevent maximize, class:^libreoffice-*"

          # Prismlauncher fix
          "float, class:^(gamescope)$"

          # Make Firefox Picture-in-Picture floating and small
          "float, title:Picture-in-Picture"
          "pin, title:Picture-in-Picture"
          "move 100%-w-10 +36, title:Picture-in-Picture" # The panel is 26 pixels + 10 = 36
          "size 25% 25%, title:Picture-in-Picture"
        ];

        workspace = [
          "special,gapsin:10,gapsout:20"
        ];

        # Permissions
        ecosystem.enforce_permissions = true;
        permission = [
          "${pkgs.grimblast}/bin/grimblast, screencopy, allow"
          "${config.programs.hyprland.portalPackage}/(lib|libexec|lib64)/xdg-desktop-portal-hyprland, screencopy, allow"
          "${pkgs.wluma}/bin/.wluma-wrapped, screencopy, allow"
        ];
      };
    };

    programs.zsh.shellAliases.clip = "cat $1 | kitten clipboard";
  };
}
