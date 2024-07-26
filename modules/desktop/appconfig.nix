{ pkgs, username, config, ... }:

{
  home-manager.users.${username} = {
    # Kitty
    programs.kitty = {
      enable = true;
      settings = {
        confirm_os_window_close = "0";
        window_padding_width = "3";
	font_family = config.stylix.fonts.monospace.name;
        font_size = "12";
        enable_audio_bell = "no";
        hide_window_decorations = "yes";
	linux_display_server = "wayland";
      };
    };

    programs.chromium = {
      enable = true;
      package = pkgs.brave;
      extensions = [
        { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; }  # Vimium
	{ id = "hmbgmokpddhjjncclckdfnolbhfjnoam"; }  # SearX
	{ id = "nngceckbapebfimnlniiiahkandclblb"; }  # Bitwarden
	{ id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; }  # Dark reader
        { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; }  # Sponsorblock
      ];
      commandLineArgs = [
        "--enable-features=TouchpadOverscrollHistoryNavigation"
	"--password-store=basic"
      ];
    };
  }; 
}
