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
