{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.nixos-config.desktop.hyprland.enable {
    home-manager.users.${config.nixos-config.username} = {
      home.packages = with pkgs; [
        gnome-calculator
        mission-center
        nautilus
        eog
        libqalculate # For walker
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
      };

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

      # Walker
      xdg.configFile = {
        "walker/config.json".text = builtins.toJSON {
          "builtins" = {
            "applications" = {
              "actions"."enabled" = false;
              "weight" = 6;
            };
            "clipboard" = {
              "switcher_only" = false;
              "prefix" = "cp";
            };
            "custom_commands"."switcher_only" = true;
            "runner"."switcher_only" = true;
            "calculator" = {
              "switcher_only" = false;
              "prefix" = "+";
            };
            "websearch"."switcher_only" = true;
            "finder" = {
              "switcher_only" = false;
              "prefix" = "fi";
            };
          };
          "list"."max_entries" = 10;
          "theme" = "custom";
        };

        # Theme
        "walker/themes/custom.json".text = builtins.toJSON {
          "ui" = {
            "anchors" = {
              "bottom" = true;
              "left" = true;
              "right" = true;
              "top" = true;
            };
            "window" = {
              "box" = {
                "ai_scroll" = {
                  "content" = {
                    "h_align" = "fill";
                    "name" = "aicontent";
                    "v_align" = "fill";
                  };
                  "h_align" = "fill";
                  "height" = 400;
                  "margins" = {
                    "top" = 5;
                  };
                  "max_height" = 400;
                  "max_width" = 500;
                  "min_width" = 500;
                  "name" = "aiscroll";
                  "v_align" = "fill";
                  "width" = 500;
                };
                "bar" = {
                  "entry" = {
                    "h_align" = "fill";
                    "h_expand" = true;
                    "icon" = {
                      "h_align" = "center";
                      "h_expand" = true;
                      "pixel_size" = 24;
                      "theme" = "Morewaita";
                    };
                  };
                  "orientation" = "horizontal";
                  "position" = "end";
                };
                "h_align" = "center";
                "margins" = {
                  "top" = 200;
                };
                "scroll" = {
                  "list" = {
                    "item" = {
                      "activation_label" = {
                        "h_align" = "fill";
                        "v_align" = "fill";
                        "width" = 100;
                        "x_align" = 0.5;
                        "y_align" = 0.5;
                      };
                      "icon" = {
                        "pixel_size" = 26;
                        "theme" = "Morewaita";
                      };
                    };
                    "margins" = {
                      "top" = 8;
                    };
                    "max_height" = 400;
                    "max_width" = 500;
                    "min_width" = 500;
                    "width" = 500;
                  };
                };
                "search" = {
                  "input" = {
                    "h_align" = "fill";
                    "h_expand" = true;
                    "icons" = true;
                  };
                  "spinner" = {
                    "hide" = true;
                  };
                };
                "width" = 500;
              };
              "h_align" = "fill";
              "v_align" = "fill";
            };
          };
        };
        "walker/themes/custom.css".text = ''
          #window {
            all: unset;
          }

          #box {
            background-color: @theme_bg_color;
            padding: 10px;
            border-radius: 15px;
            box-shadow: rgba(0, 0, 0, 0.4) 0px 0px 35px 0px;
          }

          #icon {
            margin: 3px;
            margin-right: 7px;
          }

          #label {
            font-weight: 750;
          }
        '';
      };
    };
  };
}
