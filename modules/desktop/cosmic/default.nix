{
  config,
  lib,
  inputs,
  ...
}:
{
  options.nixos-config.desktop.cosmic.enable = lib.mkEnableOption "the COSMIC desktop";

  config = lib.mkIf config.nixos-config.desktop.cosmic.enable {
    services.desktopManager.cosmic.enable = true;
    services.displayManager.cosmic-greeter.enable = true;
  };
}
