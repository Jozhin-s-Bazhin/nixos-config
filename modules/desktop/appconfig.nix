{ pkgs, username, config, ... }:

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

    programs.chromium = {
      enable = true;
      package = pkgs.brave;
      extensions = [
        { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; }  # Vimium
	{ id = "hmbgmokpddhjjncclckdfnolbhfjnoam"; }  # SearX
	{ id = "nngceckbapebfimnlniiiahkandclblb"; }  # Bitwarden
	{ id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; }  # Dark reader
        { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; }  # Sponsorblock
        { id = "fdpohaocaechififmbbbbbknoalclacl"; }  # Page screenshot
        { id = "clngdbkpkpeebahjckkjfobafhncgmne"; }  # Stylus
      ];
      commandLineArgs = [
        "--enable-features=TouchpadOverscrollHistoryNavigation"
	"--password-store=basic"
	"--enable-smooth-scrolling"
      ];
    };

    # Default apps
    home.packages = with pkgs; [
      nautilus
      eog
    ];

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        # Nautilus
        "inode/directory" = "org.gnome.Nautilus.desktop";
        
        # Eye of GNOME
        "image/jpg" = "org.gnome.eog.desktop";
        "image/png" = "org.gnome.eog.desktop";
        "image/webp" = "org.gnome.eog.desktop";
      };
    }
  }; 

  # Brave
  environment.etc."brave/policies/managed/policies.json".text = ''
    "TorDisabled"=dword:00000001
    "IPFSEnabled"=dword:00000000
    "BraveRewardsDisabled"=dword:00000001
    "BraveWalletDisabled"=dword:00000001
    "BraveVPNDisabled"=dword:00000001
    "BraveAIChatEnabled"=dword:00000000
  '';
}
