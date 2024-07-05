{ inputs, username, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  home-manager = {
    users.${username} = {
      programs.home-manager.enable = true;
      
      home = {
        inherit username;
        homeDirectory = "/home/${username}";
        stateVersion = "23.11";
      };
    };
  	backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
	  extraSpecialArgs = { inherit inputs username; };
  };
}