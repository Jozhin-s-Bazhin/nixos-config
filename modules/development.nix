{ config, pkgs, lib, ... }:

{
  options.nixos-config.development.enable = lib.mkEnableOption "and configures an IDE and adds bunch of shortcuts and packages";

  config = lib.mkIf config.nixos-config.development.enable {
    # CLI stuff
    environment.systemPackages = with pkgs; [ direnv ];

    programs.zsh = {
      interactiveShellInit = ''
        # Direnv
        eval "$(direnv hook zsh)"

        # Initialise project shortcut
        mkproject () {
          local name=$1
          local public=''${2:-0}	# Defaults to false
          mkdir ./$name
          cd ./$name
          nix flake init -t templates#utils-generic
          echo 'use flake' > .envrc
          git init
          git add -A
          echo ".direnv" > .gitignore
          git commit -m "Initial commit: added framework"
          ${pkgs.gh}/bin/gh repo create --add-readme --source=. $(if [[ "$public" -eq 1 ]]; then echo "--public"; else echo "--private"; fi)
          direnv allow
        }
      '';
      shellAliases.z = ''
				if [ $# -eq 0 ]; then
					zeditor .
				else
					zeditor "$1"
				fi
			'';
    };

    programs.git = {
      enable = true;
      config.user = {
        name = "Jozhin-s-Bazhin";
        email	= "rbezroutchko@gmail.com";
      };
    };

    # VSCode
    home-manager.users.${config.nixos-config.username}.programs.zed-editor = {
			enable = true;
			extensions = [
				"nix"
				"fleet-themes"
			];
			userSettings = {
  			telemetry = {
    			diagnostics = false;
    			metrics = false;
  			};
  			vim_mode = true;
  			theme = "Fleet Dark";
				ui_font_size = 16;
				buffer_font_size = 16;
				buffer_font_family = config.home-manager.users.${config.nixos-config.username}.stylix.fonts.monospace.name;  # Sets the font to the stylix monospace font
			};
			userKeymaps = [
 			  {
          context = "vim_mode == insert";
          bindings."j k" = "vim::NormalBefore";
   			}
			];
    };
  };
}
