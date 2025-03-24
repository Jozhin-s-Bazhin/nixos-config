{
  config,
  lib,
  ...
}:

{
  config = lib.mkIf config.nixos-config.desktop.hyprland.enable {
    home-manager.users.${config.nixos-config.username} = {
      wayland.windowManager.hyprland.settings = {
        monitor = [
          ", preferred, auto, 1, cm, auto"

          # Ultrawide at home
          "desc:Huawei Technologies Co. Inc. ZQE-CAA 0xC080F622, preferred, -3440x0, 1" # Right of eDP-1

          # Monitor at home
          #"desc:Iiyama North America PL2283H 1132555227963, preferred, 0x-1080, 1"  # Above eDP-1
        ];

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
      };
    };

    programs.zsh.shellAliases.clip = "cat $1 | kitten clipboard";
  };
}
