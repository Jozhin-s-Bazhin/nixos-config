{
  config,
  pkgs,
  lib,
  ...
}:

{
  options.nixos-config.development.enable = lib.mkEnableOption "and configures an IDE and adds bunch of shortcuts and packages";

  config = lib.mkIf config.nixos-config.development.enable {
    nixos-config.desktop.enable = true;

    # CLI stuff
    environment.systemPackages = with pkgs; [ direnv ];

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
          nix flake init -t templates#utils-generic
          echo 'use flake' > .envrc
          ${pkgs.gh}/bin/gh repo create --add-readme --source=. $(if [[ "$public" -eq 1 ]]; then echo "--public"; else echo "--private"; fi)
          direnv allow
          git init
          echo ".direnv" > .gitignore
          git add -A
          git commit -m "Initial commit: added framework"
        }
      '';
      shellAliases.z = ''
        if [ $# -eq 0 ]; then
          zeditor .
        else
          zeditor "$1"
        fi
        exit
      '';
    };

    programs.git = {
      enable = true;
      config = {
        user = {
          name = "Jozhin-s-Bazhin";
          email = "rbezroutchko@gmail.com";
        };
        push.autoSetupRemote = true;
      };
    };

    # Zed
    home-manager.users.${config.nixos-config.username} = {
      home.packages = with pkgs; [
        nil
        nixd
        clang-tools
      ];
      programs.zed-editor = {
        enable = true;
        extensions = [ "nix" ];
        userSettings = {
          telemetry = {
            diagnostics = false;
            metrics = false;
          };
          vim_mode = true;
          load_direnv = "shell_hook";
          ui_font_size = lib.mkForce 16;
          buffer_font_size = lib.mkForce 16;
          autosave = "on_window_change";
          terminal.env.TERM = "alacritty";
          lsp = {
            nil.binary.pathLookUp = true;
            clangd.binary.pathLookUp = true;
          };
          languages = {
            Nix = {
              tab_size = 2;
              hard_tabs = false;
              formatter.external = {
                command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
                arguments = [
                  "--quiet"
                  "--"
                ];
              };
            };
          };
          assistant = {
            version = "2";
            default_model = {
              provider = "ollama";
              model = "deepseek-r1:8b";
            };
          };
          language_models.ollama = {
            api_url = "http://localhost:11434";
            available_models = [
              {
                name = "deepseek-r1:8b";
                display_name = "Deepseek R1 8B";
                max_tokens = 16384;
              }
            ];
          };
        };
        userKeymaps = [
          {
            context = "vim_mode == insert";
            bindings."j k" = "vim::NormalBefore";
          }
        ];
      };
    };
    services.ollama = {
      enable = true;
      loadModels = [ "deepseek-r1:1.5b" ];
    };
  };
}
