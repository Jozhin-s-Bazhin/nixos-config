{
  config,
  pkgs,
  lib,
  ...
}:

let
  file = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/zed-industries/zed/main/assets/prompts/content_prompt.hbs";
    sha256 = "17fc52is4zial3664sqglwkbwn8cmh0nfahpdfjr17x9xlsf3b46";
  };
  patch = pkgs.writeText "patch" ''
    @@ -29,11 +29,8 @@ Generate {{content_type}} based on the following prompt:

     Match the indentation in the original file in the inserted {{content_type}}, don't include any indentation on blank lines.

    -Immediately start with the following format with no remarks:
    +Immediately start your response with no remarks before nor after, only the code to insert.

    -```
    -\{{INSERTED_CODE}}
    -```
     {{else}}
     Edit the section of {{content_type}} in <rewrite_this></rewrite_this> tags based on the following prompt:

    @@ -67,9 +64,6 @@ Only make changes that are necessary to fulfill the prompt, leave everything els

     Start at the indentation level in the original file in the rewritten {{content_type}}. Don't stop until you've rewritten the entire section, even if you have no more changes to make, always write out the whole section with no unnecessary elisions.

    -Immediately start with the following format with no remarks:
    +Immediately start your response with no remarks before nor after, only the rewritten code.

    -```
    -\{{REWRITTEN_CODE}}
    -```
     {{/if}}
  '';
  package = pkgs.stdenv.mkDerivation {
    name = "patchedFile";
    dontUnpack = true;
    buildPhase = ''
      cp ${file} patchedFile
      patch patchedFile ${patch}
    '';
    installPhase = ''
      mkdir -p $out
      cp patchedFile $out/patchedFile
    '';
  };
  promptFile = "${package}/patchedFile";
in
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
          features.edit_prediction_provider = "zed";
          assistant = {
            version = "2";
            default_model = {
              provider = "ollama";
              model = "qwen2.5-coder:14b";
            };
          };
          language_models.ollama = {
            api_url = "http://localhost:11434";
            low_speed_timeout_in_seconds = 300;
            available_models = [
              {
                name = "qwen2.5-coder:14b";
                display_name = "Qwen 2.5 Coder 14B";
                max_tokens = 32768;
                keep_alive = "30m";
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
      xdg.configFile."zed/prompt_overrides/content_prompt.hbs".source = promptFile;
    };
    services.ollama = {
      enable = true;
      loadModels = [ "qwen2.5-coder:14b" ];
    };
  };
}
