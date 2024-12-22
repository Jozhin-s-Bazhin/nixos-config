{ pkgs, username, ... }:
{
	home-manager.users.${username}.home.packages = with pkgs; [ 
		qbittorrent
		celluloid
		stremio
		foliate
	];
}
