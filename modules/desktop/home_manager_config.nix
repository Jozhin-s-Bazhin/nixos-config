{ inputs, config, lib, ... }:

{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  config = lib.mkIf config.nixos-config.desktop.enable {
    home-manager = {
      users.${config.nixos-config.username} = {
        nixpkgs.config.allowUnfree = true;
        programs.home-manager.enable = true;
        
        home = {
          username = config.nixos-config.username;
          homeDirectory = "/home/${config.nixos-config.username}";
          stateVersion = "23.11";
        };
      };
      backupFileExtension = "backup";
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = { inherit inputs; };
    };
  };
}
