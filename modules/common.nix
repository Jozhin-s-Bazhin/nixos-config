{ pkgs, name, username, ... }:

{
  # Do not touch
  system.stateVersion = "23.11";

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Firmware
  hardware.enableAllFirmware = true;
  
  # Timezone and locale
  time.timeZone = "Europe/Brussels";
  i18n.defaultLocale = "en_US.UTF-8";
  
  # User
  users.users.${username} = {
    isNormalUser = true;
    description = "";
    extraGroups = [ "wheel" "audio" ];
  };
  
  # Nix config
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;
  
  # Auto cleanup
  nix.optimise = {
    automatic = true;
    dates = [ "3:00" ];
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  # I don't want automatic upgrades on a server
  
  # Running non-NixOS binaries
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Put missing libraries here
  ];

  # CLI aliases and preferences
  environment.systemPackages = with pkgs; [
    killall
    eza
    zoxide
    bat
    tldr
    bc
  ];
  
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    vteIntegration = true;

    # Init
    interactiveShellInit  = ''
      # Zoxide
      eval "$(zoxide init --cmd cd zsh)"

      # Yazi
      function f() {
	      local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	      yazi "$@" --cwd-file="$tmp"
	      if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		      cd -- "$cwd"
	      fi
	      rm -f -- "$tmp"
      }

      # Vim keybinds
      bindkey -v
      bindkey "^H" backward-delete-char
      bindkey "^?" backward-delete-char
      bindkey -M viins 'jk' vi-cmd-mode
    '';

    # Aliases
    shellAliases = {
      # nvim
      v = "nvim";

      # basic 
      ls = "eza -l --git --sort 'modified'";
      grep = "grep --color=auto";
      cat = "bat";

      # Misc
      c = "codium . && exit";
      clip = "kitten clipboard";

      # Nix rebuilds
      rbs = pkgs.writeShellScript "rebuild-switch.sh" ''
        BLUE='\033[1;34m'
        NC='\033[0m'
        echo -e "$BLUE"
        echo -e "Started system rebuild"
        echo -e "$BLUE"
        echo -e "Starting nixos-rebuild switch ..."
        echo -e "$NC"
        sudo nixos-rebuild switch --flake /home/${username}/nixos-config#${name}
        echo -e "$BLUE Committing..."
        echo -e "$NC"
        date=$(date)
        git -C /home/${username}/nixos-config add -A > /dev/null
        git -C /home/${username}/nixos-config commit -m "[ $date ] nixos-rebuild switch --flake /home/${username}/nixos-config#${name}" 
        git -C /home/${username}/nixos-config push -q
        echo -e "$BLUE"
        echo -e "Finished $NC" 
      '';
    };
  };
  users.defaultUserShell = pkgs.zsh;
  environment.pathsToLink = [ "/share/zsh" ];

  # NeoVim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    configure.customRC = ''
      inoremap jk <Esc>
      set ignorecase
    '';
  };
}
