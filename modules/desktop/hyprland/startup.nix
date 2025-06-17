{
  config,
  pkgs,
  lib,
  ...
}:

{
  config = lib.mkIf (config.nixos-config.desktop.desktop == "hyprland") {
    home-manager.users.${config.nixos-config.username} = {
      wayland.windowManager.hyprland.settings.exec-once = [
        # Clipboard
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"

        # Automount USB drives
        "${pkgs.udiskie}/bin/udiskie"

        # wlsunset
        "${pkgs.writers.writeBash "wlsunset" ''
          location=$(curl -s ipinfo.io/loc);
          fallback_sunrise="7:00";
          fallback_sunset="18:30";

          if [ $? -eq 0 ] && [ -n "$location" ]; then
            latitude=$(echo $location | cut -d',' -f1);
            longitude=$(echo $location | cut -d',' -f2);
            ${pkgs.wlsunset}/bin/wlsunset -l $latitude -L $longitude;
          else
            ${pkgs.wlsunset}/bin/wlsunset -S $fallback_sunrise -s $fallback_sunset;
          fi
        ''}"

        # Walker
        "${pkgs.walker}/bin/walker --gapplication-service"
      ];
      home.packages = with pkgs; [
        wl-clipboard
        cliphist
      ];
    };
  };
}
