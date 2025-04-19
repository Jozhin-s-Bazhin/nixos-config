{
  config,
  lib,
  inputs,
  ...
}:
{
  imports = [ inputs.nixos-cosmic.nixosModules.default ];

  options.nixos-config.desktop.cosmic.enable = lib.mkEnableOption "the COSMIC desktop";

  config = lib.mkIf config.nixos-config.desktop.cosmic.enable {
    nixos-config.desktop.hyprland.enable = true;
    nix.settings = {
      substituters = [ "https://cosmic.cachix.org/" ];
      trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
    };
    /*
      services.desktopManager.cosmic.enable = true;
      services.displayManager.cosmic-greeter.enable = true;
    */
  };
}
