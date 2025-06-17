{
  config,
  lib,
  inputs,
  ...
}:
{
  config = lib.mkIf (config.nixos-config.desktop.desktop == "cosmic") {
    services.desktopManager.cosmic.enable = true;
    services.displayManager.cosmic-greeter.enable = true;
  };
}
