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

      xdg.configFile = {
        "walker/config.json".text = builtins.toJSON {
          "builtins" = {
            "applications" = {
              "actions" = false;
              "weight" = 6;
            };
            "clipboard" = {
              "switcher_only" = false;
              "max_entries" = 5;
            };
            "custom_commands"."switcher_only" = true;
            "runner"."switcher_only" = true;
            "websearch"."switcher_only" = true;
          };
          "list"."max_entries" = 6;
          "theme" = "custom";
        };
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
                  "max_width" = 400;
                  "min_width" = 400;
                  "name" = "aiscroll";
                  "v_align" = "fill";
                  "width" = 400;
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
                        "width" = 20;
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
                    "max_height" = 300;
                    "max_width" = 400;
                    "min_width" = 400;
                    "width" = 400;
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
                "width" = 450;
              };
              "h_align" = "fill";
              "v_align" = "fill";
            };
          };
        };
        "walker/themes/custom.css".text = ''
          #window,
          #box,
          #aiscroll,
          #aicontent,
          #search,
          #password,
          #input,
          #typeahead,
          #list,
          child,
          scrollbar,
          slider,
          #item,
          #text,
          #label,
          #bar,
          #sub,
          #activationlabel {
            all: unset;
          }

          #window {
            color: @theme_fg_color;
          }

          #aiscroll,
          #aicontent,
          #aicontent > *:first-child {
            background: none;
            color: inherit;
          }

          #box {
            border-radius: 10px;
            border: 1px solid @wm_borders_edge;
            padding: 10px;
            background-color: @theme_bg_color;
          }

          #password,
          #input,
          #typeahead {
            background: lighter(@theme_bg_color);
            padding: 5px;
            border-radius: 5px;
          }

          #input {
            background: none;
          }

          #typeahead {
            color: hsl(174, 89.7%, 32.7%);
          }

          #input > *:first-child,
          #typeahead > *:first-child {
            margin-right: 4px;
            margin-left: 4px;
            color: @theme_fg_color;
          }

          #input > *:last-child,
          #typeahead > *:last-child {
            color: @theme_fg_color;
          }

          child {
            padding: 5px;
            border-radius: 5px;
          }

          child:selected,
          child:hover {
            background: lighter(@theme_bg_color);
          }

          #icon {
            margin-right: 8px;
          }

          #label {
            font-weight: 500;
          }

          #sub {
            opacity: 0.5;
            font-size: 0.8em;
          }

          .activation #text,
          .activation #icon,
          .activation #search {
            opacity: 0.5;
          }
        '';
      };
    };
  };
}
