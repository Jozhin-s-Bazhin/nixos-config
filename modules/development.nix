{ config, pkgs, lib, username, ... }:

{
  # Virtualisation
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      ovmf.enable = true; 
      swtpm.enable = true; 
    };
  };
  programs.virt-manager.enable = true;
  users.users.${username}.extraGroups = [ "libvirtd" ];
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
  
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
        local public=''${2:-0}  # Defaults to false
	mkdir ./$name
	cd ./$name
        nix flake init
	echo 'use flake' > .envrc
	git init
	git add -A
	git commit -m "Initial commit: added framework"
	gh repo create --add-readme --source=. $(if [[ "$public" -eq 1 ]]; then echo "--public"; else echo "--private"; fi)
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
      email  = "rbezroutchko@gmail.com";
    };
  };
  
  # VSCode settings if you have a graphical environment
  home-manager.users.${username}.programs.vscode = {
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
      "vscode-neovim.compositeKeys" = {
        "jk" = {
        "command" = "vscode-neovim.escape";
        };
      };
    };
  };
}
