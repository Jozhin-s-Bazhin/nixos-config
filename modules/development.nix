{ config, pkgs, lib, username, ... }:

{
  # Virtualisation
  #virtualisation.vmware.host.enable = true;  # Breaks on latest kernel. Too lazy to fix
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
    poetry
  ];
  
  programs.zsh = {
    interactiveShellInit = ''
      # Direnv
      eval "$(direnv hook zsh)"
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