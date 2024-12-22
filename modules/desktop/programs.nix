{ pkgs, inputs, username, ... }:

{
	home-manager.users.${username} = {
		home.packages = with pkgs; [
			thunderbird
			bitwarden
			spotube
			obsidian
			alpaca
			whatsapp-for-linux
		];
	};
}
