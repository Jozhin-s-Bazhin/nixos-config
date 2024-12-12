{ pkgs, username, config, inputs, ... }:
let
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
in
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

    # Librewolf
    programs.firefox = {
      enable = true;
      package = (pkgs.wrapFirefox (pkgs.librewolf-unwrapped.override { pipewireSupport = true;}) {});
      policies = {
        DisplayBookmarksToolbar = "never";
	DisplayMenuBar = "never";
	SearchBar = "unified";
	OfferToSaveLogins = false;
	PasswordManagerEnabled = false;

	Preferences = {
	  "widget.gtk.native-context-menus" = lock-true;
	  "widget.gtk.non-native-titlebar-buttons.enabled" = lock-false;
          "sidebar.verticalTabs" = lock-true;
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

          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
	    install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden/latest.xpi";
	    installation_mode = "force_installed";
	  };
	};
      };
    };
  }; 
}
