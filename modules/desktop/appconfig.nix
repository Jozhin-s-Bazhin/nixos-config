{ pkgs, username, config, inputs, ... }:

{
  home-manager.users.${username} = {
    # Kitty
    programs.kitty = {
      enable = true;
      settings = {
        confirm_os_window_close = "0";
        window_padding_width = "3";
        font_size = "14";
        enable_audio_bell = "no";
        hide_window_decorations = "yes";
	linux_display_server = "wayland";
      };
    };

    /*programs.chromium = {
      enable = true;
<<<<<<< HEAD
<<<<<<< HEAD
      package = (pkgs.wrapFirefox (pkgs.librewolf-unwrapped.override { pipewireSupport = true;}) {});
      policies = {
        DisplayBookmarksToolbar = "never";
	DisplayMenuBar = "never";
	SearchBar = "unified";
	OfferToSaveLogins = false;
	PasswordManagerEnabled = false;
	Homepage = {
	  URL = "about:blank";
	};

	Preferences = {
	  "widget.gtk.native-context-menus" = lock-true;
	  "widget.gtk.non-native-titlebar-buttons.enabled" = lock-false;
          "sidebar.verticalTabs" = lock-true;
	  "browser.newtabpage.enabled" = lock-false;
	};

	# Librewolf policies
	DisableAppUpdate = true;
	AppUpdateURL = "https://localhost/";
	OverrideFirstRunPage = "";
	OverridePostUpdatePage = "";
	DisableSystemAddonUpdate = true;
	DisableProfileImport = false;
	DisableFirefoxStudies = true;
	DisableTelemetry = true;
	DisablePocket = true;
	DisableFeedbackCommands = true;
	DisableSetDesktopBackground = false;
	DisableDeveloperTools = false;
	NoDefaultBookmarks = true;
	WebsiteFilter = "{\"Block\":[\"https://localhost/*\"],\"Exceptions\":[\"https://localhost/*\"]}";

	# Extensions
	ExtensionSettings = {
	  "*".installation_mode = "blocked";

          # Ublock
	  "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };

          # Dark Reader
	  "addon@darkreader.org" = {
	    install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
	    installation_mode = "force_installed";
	  }; 

          # Vimium
          "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
	    install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi";
	    installation_mode = "force_installed";
	  };

	  # Bitwarden
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
	    install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
	    installation_mode = "force_installed";
	  };
	};
      };
    };
=======
=======
>>>>>>> parent of 5e8ce03 (desktop: switch from zen to librewolf)
      package = pkgs.brave;
      extensions = [
        { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; }  # Vimium
	{ id = "hmbgmokpddhjjncclckdfnolbhfjnoam"; }  # SearX
	{ id = "nngceckbapebfimnlniiiahkandclblb"; }  # Bitwarden
	{ id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; }  # Dark reader
        { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; }  # Sponsorblock
        { id = "fdpohaocaechififmbbbbbknoalclacl"; }  # Page screenshot
      ];
      commandLineArgs = [
        "--enable-features=TouchpadOverscrollHistoryNavigation"
	"--password-store=basic"
	"--enable-smooth-scrolling"
      ];
    };*/
    home.packages = [ inputs.zen.packages."${pkgs.stdenv.hostPlatform.system}".specific ];
<<<<<<< HEAD
>>>>>>> parent of 5e8ce03 (desktop: switch from zen to librewolf)
=======
>>>>>>> parent of 5e8ce03 (desktop: switch from zen to librewolf)
  }; 

  /*# Brave
  environment.etc."brave/policies/managed/policies.json".text = ''
    "TorDisabled"=dword:00000001
    "IPFSEnabled"=dword:00000000
    "BraveRewardsDisabled"=dword:00000001
    "BraveWalletDisabled"=dword:00000001
    "BraveVPNDisabled"=dword:00000001
    "BraveAIChatEnabled"=dword:00000000
  '';*/
}
