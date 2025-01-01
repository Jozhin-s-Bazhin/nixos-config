{ pkgs, config, lib, ... }:

{
  options.nixos-config.common.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enables a bunch of stuff I want on any system and stuff NixOS needs to be enabled.";
  };

  config = lib.mkIf config.nixos-config.common.enable {
    # Do not touch
    system.stateVersion = "23.11";

    # Bootloader
    boot.loader = {
      systemd-boot = {
        enable = true;
        editor = false;
      };
      efi.canTouchEfiVariables = true;
    };
    
    # Firmware
    hardware.enableAllFirmware = true;
    
    # Timezone and locale
    time.timeZone = "Europe/Brussels";
    i18n.defaultLocale = "en_US.UTF-8";

    # Enable zram
    zramSwap.enable = true;
    
    # User
    users.users.${config.nixos-config.username} = {
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
    
    # Running non-NixOS binaries
    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [
      # Put missing libraries here
    ];
    environment.etc."/bin/bash".source = "${pkgs.bash}/bin/bash";

    # CLI aliases and preferences
    environment.systemPackages = with pkgs; [
      killall
      zoxide
      tldr
      htop 
			thefuck
		];
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      autosuggestions.enable = true;
      vteIntegration = true;

      # Init
      interactiveShellInit	= ''
        # Zoxide
        eval "$(zoxide init --cmd cd zsh)"

        # Yazi
        function f() {
          local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
          ${pkgs.yazi}/bin/yazi "$@" --cwd-file="$tmp"
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

				# thefuck
				eval "$(thefuck --alias)"
      '';

      promptInit = ''
        export PROMPT='%F{blue}%F{white}%K{blue}%n@%m%F{blue}%k%f %~ '
      '';

      # Aliases
      shellAliases = {
        # nvim
        v = "nvim";

        # basic 
        ls = "${pkgs.eza}/bin/eza -l --git --sort 'modified'";
        grep = "grep --color=auto";
        cat = "${pkgs.bat}/bin/bat";
        less = "${pkgs.bat}/bin/bat";

        # Nix aliases
        rbs = pkgs.writeShellScript "rebuild-switch.sh" ''
          # Colors
          BLUE='\033[1;34m'
          RED='\033[1;31m'
          NC='\033[0m'
          
          # Ask sudo password immediately so it's cached, otherwise you may forget to input it later
					(
          echo -e "$BLUE"
          sudo echo -e "Authentication successful $NC" &&
 
          # Commit and push changes
          echo -e "$BLUE"
          echo -e "Committing..."
          echo -e "$NC"
          git -C ${config.nixos-config.configDir} add -A > /dev/null &&
          git -C ${config.nixos-config.configDir} commit &&
          git -C ${config.nixos-config.configDir} push -q &&
          # Start nixos-rebuild switch
          echo -e "$BLUE" &&
          echo -e "Starting nixos-rebuild switch ..." &&
          echo -e "$NC" &&
          sudo nixos-rebuild switch --flake ${config.nixos-config.configDir}#${config.networking.hostName} &&
          
          # Finish
          echo -e "$BLUE" &&
          echo -e "Finished $NC" 
					) || (
          echo -e "$RED" &&
          echo -e "Command failed $NC"
					)
        '';
				rbnc = pkgs.writeShellScript "rebuild-no-commit" ''
          # Colors
	        BLUE='\033[1;34m'
          RED='\033[1;31m'
          NC='\033[0m'
          
          # Ask sudo password immediately so it's cached, otherwise you may forget to input it later
					(
          echo -e "$BLUE"
          sudo echo -e "Authentication successful $NC" &&
 
          # Start nixos-rebuild switch
          echo -e "$BLUE"
          echo -e "Starting nixos-rebuild switch ..."
          echo -e "$NC"
          sudo nixos-rebuild switch --flake ${config.nixos-config.configDir}#${config.networking.hostName} &&
          
          # Finish
          echo -e "$BLUE" &&
          echo -e "Finished $NC" 
					) || (
          echo -e "$RED" &&
          echo -e "Command failed $NC"
					)
				'';
        rbu = pkgs.writeShellScript "rebuild-update.sh" ''
          # Colors
          BLUE='\033[1;34m'
          RED='\033[1;31m'
          NC='\033[0m'
          
          # Ask sudo password immediately so it's cached, otherwise you may forget to input it later
					(
          echo -e "$BLUE"
          sudo echo -e "Authentication successful $NC" &&
          
          # Update flake.lock
          echo -e "$BLUE" &&
          echo -e "Updating flake.lock..." &&
          echo -e "$NC" &&
					nix flake update --flake ${config.nixos-config.configDir} &&
          
          # Start nixos-rebuild switch
          echo -e "$BLUE" &&
          echo -e "Starting nixos-rebuild switch ..." &&
          echo -e "$NC" &&
          sudo nixos-rebuild switch --flake ${config.nixos-config.configDir}#${config.networking.hostName} &&
          
          # Commit and push changes
          echo -e "$BLUE" &&
          echo -e "Committing..." &&
          echo -e "$NC" &&
          git -C ${config.nixos-config.configDir} add -A > /dev/null &&
          git -C ${config.nixos-config.configDir} commit -m "Update flake.lock" &&
          git -C ${config.nixos-config.configDir} push -q &&
          
          # Finish
          echo -e "$BLUE" &&
          echo -e "Finished $NC" 
					) || (

					# Clean up flake.lock
          git -C ${config.nixos-config.configDir} restore . --staged &&
          git -C ${config.nixos-config.configDir} restore . &&
          echo -e "$RED" &&
          echo -e "Command failed $NC"
					)
        '';
				rbt = pkgs.writeShellScript "rebuild-test" ''
          # Colors
	        BLUE='\033[1;34m'
          RED='\033[1;31m'
          NC='\033[0m'
          
          # Ask sudo password immediately so it's cached, otherwise you may forget to input it later
          (
					echo -e "$BLUE"
          sudo echo -e "Authentication successful $NC" &&
 
          # Start nixos-rebuild test
          echo -e "$BLUE"
          echo -e "Starting nixos-rebuild test ..."
          echo -e "$NC"
          sudo nixos-rebuild test --flake ${config.nixos-config.configDir}#${config.networking.hostName} &&
          
          # Finish
          echo -e "$BLUE" &&
          echo -e "Finished $NC"
					) || (
          echo -e "$RED"
          echo -e "Command failed $NC"
					)
				'';
        rbb = pkgs.writeShellScript "rebuild-boot.sh" ''
          # Colors
          BLUE='\033[1;34m'
          RED='\033[1;31m'
          NC='\033[0m'
          
          # Ask sudo password immediately so it's cached, otherwise you may forget to input it later
					(
          echo -e "$BLUE"
          sudo echo -e "Authentication successful $NC" &&
 
          # Commit and push changes
          echo -e "$BLUE"
          echo -e "Committing..."
          echo -e "$NC"
          git -C ${config.nixos-config.configDir} add -A > /dev/null &&
          git -C ${config.nixos-config.configDir} commit &&
          git -C ${config.nixos-config.configDir} push -q &&
          
          # Start nixos-rebuild boot
          echo -e "$BLUE" &&
          echo -e "Starting nixos-rebuild boot ..." &&
          echo -e "$NC" &&
          sudo nixos-rebuild boot --flake ${config.nixos-config.configDir}#${config.networking.hostName} &&
          
          # Finish
          echo -e "$BLUE" &&
          echo -e "Finished" &&
					echo -e "Rebooting" &&
					systemctl reboot 
					) || (
          echo -e "$RED" &&
          echo -e "Command failed $NC"
					)
        '';

        nsp = "nix-shell -p";
      };
    };
    users.defaultUserShell = pkgs.zsh;
    environment.pathsToLink = [ "/share/zsh" ];

		# Set $NIX_PATH
		nix.nixPath = [
			"nixpkgs=flake:nixpkgs:/nix/var/nix/profiles/per-user/root/channels"
			"nixos-config=${config.nixos-config.configDir}"
		];

    # NeoVim
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;
      configure.customRC = ''
        inoremap jk <Esc>
        set ignorecase
        set tabstop=2
        set shiftwidth=2
        hi Normal guibg=NONE ctermbg=NONE
      '';
    };
  };
}
