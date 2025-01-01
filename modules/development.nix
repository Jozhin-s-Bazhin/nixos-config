{ config, pkgs, lib, ... }:

let
	flaketext = ''
{
  description = "A simple flake with a devshell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
		devShell = pkgs.mkShell {
			buildInputs = with pkgs; [
				pkgs.hello
			];
		};
  };
}
	'';
in
{
  options.nixos-config.development.enable = lib.mkEnableOption "and configures an IDE and adds bunch of shortcuts and packages";
  
  config = lib.mkIf config.nixos-config.development.enable {
    # CLI stuff
    environment.systemPackages = with pkgs; [
      direnv
      gh
    ];
    
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
          nix flake init
					echo ${flaketext} > flake.nix
          echo 'use flake' > .envrc
          git init
          git add -A
          echo ".direnv" > .gitignore
          git commit -m "Initial commit: added framework"
          gh repo create --add-readme --source=. $(if [[ "$public" -eq 1 ]]; then echo "--public"; else echo "--private"; fi)
          direnv allow
        }
      '';
      shellAliases = {
        c = "codium . && exit";
      };
    };
    
    programs.git = {
      enable = true;
      config.user = {
        name = "Jozhin-s-Bazhin";
        email	= "rbezroutchko@gmail.com";
      };
    };
    
    # VSCode settings if you have a graphical environment
    home-manager.users.${config.nixos-config.username}.programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      mutableExtensionsDir = false;
      extensions = with pkgs.vscode-extensions; [
        asvetliakov.vscode-neovim
        ms-python.python
        ms-python.vscode-pylance
        jnoortheen.nix-ide
        ms-vscode.cpptools
        mkhl.direnv
        formulahendry.code-runner
      ];
      userSettings = {
        vscode-neovim.neovimExecutablePaths.linux = "${pkgs.neovim}/bin/nvim";
        extensions.experimental.affinity."asvetliakov.vscode-neovim" = 1;
        "window.titleBarStyle" = "native";
        "git.confirmSync" = false;
        "vscode-neovim.compositeKeys"."jk"."command" = "vscode-neovim.escape";
        "git.openRepositoryInParentFolders" = "always";
        "explorer.confirmDelete" = "false";

        # 2 spaces instead of tab
        "editor.tabSize" = 2;
        "editor.insertSpaces" = false;
        "editor.detectIndentation" = false;
      };
    };
  };
}
