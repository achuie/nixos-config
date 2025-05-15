{ config, lib, pkgs, ... }:

let
  modifier = config.wayland.windowManager.sway.config.modifier;
  cfg = config.wayland.windowManager.sway.config;

  ws1 = "1";
  ws2 = "2";
  ws3 = "3";
  ws4 = "4";
  ws5 = "5";
  ws6 = "6";
  ws7 = "7";
  ws8 = "8";
  ws9 = "9";
  ws10 = "10";

  dyn_tags = pkgs.writeShellScript "dyn_tags" ''
    # Focus a workspace or create a new one.

    SWAYMSG=${pkgs.sway}/bin/swaymsg
    JQ=${pkgs.jq}/bin/jq
    MENU="${pkgs.tofi}/bin/tofi"

    MOVE=""
    MENUPROMPT="switch:"
    if [ $1 = "move" ]; then
      MOVE="-t command move"
      MENUPROMPT="move:"
    fi

    $SWAYMSG $MOVE workspace $($SWAYMSG -t get_workspaces | $JQ -M '.[] | .name' \
      | tr -d '"' | sort -u | $MENU -c ${./tofi_run_theme} --anchor=bottom \
      --prompt-text=" $MENUPROMPT " --margin-bottom=24 --require-match=false)
  '';
  color-picker = pkgs.writeShellScriptBin "color-picker" ''
    # Pick a color to clipboard

    GRIM=${pkgs.grim}/bin/grim
    SLURP=${pkgs.slurp}/bin/slurp
    CONVERT=${pkgs.imagemagick}/bin/magick
    WLCOPY=${pkgs.wl-clipboard-rs}/bin/wl-copy

    $GRIM -g "$($SLURP -p)" -t ppm - | $CONVERT - -format '%[pixel:p{0,0}]' txt:- | $WLCOPY
  '';
in
{
  home.packages = with pkgs; [
    tofi
    i3status-rust
    jq
    grim
    slurp
    imagemagick
    wl-clipboard-rs
    libnotify
    swayidle
    bc
    color-picker
  ];
  programs = {
    swayimg = {
      enable = true;
      settings = { viewer = { window = "#ffffffff"; }; };
    };
    hyprlock = {
      enable = true;
      settings = {
        general = { ignore_empty_input = true; };
        background = [
          {
            path = "~/.background-image";
          }
        ];
        label = [
          {
            monitor = "";
            text = "$TIME";
            color = "rgba(211, 215, 235, 1.0)";
            font_size = 80;
            font_family = "Fira Code Custom";
            position = "0, 200";
            halign = "center";
            valign = "center";
            shadow_passes = 2;
          }
          {
            monitor = "";
            text = ''cmd[update:5000] echo "$(date +'%A, %B %e, %Y')"'';
            color = "rgba(211, 215, 235, 1.0)";
            font_size = 24;
            font_family = "Fira Code Custom";
            position = "0, 100";
            halign = "center";
            valign = "center";
            shadow_passes = 2;
            shadow_size = 5;
          }
        ];
        input-field = [
          {
            monitor = "";
            size = "20%, 5%";
            outline_thickness = 3;
            inner_color = "rgba(50, 52, 74, 0.7)";
            outer_color = "rgba(33ccffee) rgba(00ff99ee) 45deg";
            check_color = "rgba(00ff99ee) rgba(ff6633ee) 120deg";
            fail_color = "rgba(ff6633ee) rgba(ff0066ee) 40deg";
            capslock_color = "rgba(ff9e64ee) rgba(ff7800ee) 20deg";
            font_color = "rgb(143, 143, 143)";
            font_family = "Iosevka Custom";
            fade_on_empty = false;
            rounding = 15;
            position = "0, -20";
            halign = "center";
            valign = "center";
            shadow_passes = 2;
          }
        ];
      };
    };
  };
  services = {
    dunst = {
      enable = true;
      iconTheme = {
        package = config.home.pointerCursor.package or pkgs.adwaita-icon-theme;
        name = config.home.pointerCursor.name or "Adwaita";
      };
      configFile = "${./dunstrc}";
    };
    swayidle = {
      enable = true;
      extraArgs = [ "-w" ];
      events = [];
      timeouts = [
        {
          timeout = 15;
          command = ''if ${pkgs.procps}/bin/pgrep -x hyprlock; then ${pkgs.sway}/bin/swaymsg "output * power off"; fi'';
          resumeCommand = ''${pkgs.sway}/bin/swaymsg "output * power on"'';
        }
      ];
    };
  };
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # Fixes common issues with GTK 3 apps
    systemd.enable = true;
    config = {
      modifier = "Mod4";
      floating.modifier = "${modifier}";
      menu = ''${pkgs.tofi}/bin/tofi-run -c ${./tofi_run_theme} | xargs swaymsg exec --'';
      workspaceAutoBackAndForth = true;
      fonts = { names = [ "Fira Code Custom" ]; size = 10.0; };
      keybindings = lib.mkOptionDefault {
        # #i3-sensible-terminal
        "${modifier}+Return" = "exec wezterm";

        # kill focused window
        "${modifier}+Shift+q" = "kill";

        # start dmenu (a program launcher)
        "${modifier}+d" = ''exec --no-startup-id ${cfg.menu}'';

        # change focus
        "${modifier}+h" = "focus left";
        "${modifier}+j" = "focus down";
        "${modifier}+k" = "focus up";
        "${modifier}+l" = "focus right";

        # alternatively, you can use the cursor keys:
        "${modifier}+Left" = "focus left";
        "${modifier}+Down" = "focus down";
        "${modifier}+Up" = "focus up";
        "${modifier}+Right" = "focus right";

        # move focused window
        "${modifier}+Shift+h" = "move left";
        "${modifier}+Shift+j" = "move down";
        "${modifier}+Shift+k" = "move up";
        "${modifier}+Shift+l" = "move right";

        # alternatively, you can use the cursor keys:
        "${modifier}+Shift+Left" = "move left";
        "${modifier}+Shift+Down" = "move down";
        "${modifier}+Shift+Up" = "move up";
        "${modifier}+Shift+Right" = "move right";

        # toggle sticky (only for floating windows)
        "${modifier}+g" = "sticky toggle";

        # split in horizontal orientation
        "${modifier}+b" = "split h";

        # split in vertical orientation
        "${modifier}+v" = "split v";

        # enter fullscreen mode for the focused container
        "${modifier}+f" = "fullscreen toggle";

        # change container layout (stacked, tabbed, toggle split)
        "${modifier}+s" = "layout stacking";
        "${modifier}+w" = "layout tabbed";
        "${modifier}+e" = "layout toggle split";

        # toggle tiling / floating
        "${modifier}+Shift+space" = "floating toggle";

        # change focus between tiling / floating windows
        "${modifier}+space" = "focus mode_toggle";

        # focus the parent container
        "${modifier}+a" = "focus parent";

        # focus the child container
        "${modifier}+c" = "focus child";
        # dynamic tagging
        "${modifier}+x" = "exec --no-startup-id ${dyn_tags}";
        "${modifier}+Shift+x" = "exec --no-startup-id ${dyn_tags} move";
        # bindsym $mod+Shift+t exec i3-input -F 'rename workspace to %s' -P 'New name: '
        # bindsym $mod+t exec i3-input -F 'workspace %s' -P 'Navigate to: '

        # switch to workspace
        "${modifier}+1" = "workspace number ${ws1}";
        "${modifier}+2" = "workspace number ${ws2}";
        "${modifier}+3" = "workspace number ${ws3}";
        "${modifier}+4" = "workspace number ${ws4}";
        "${modifier}+5" = "workspace number ${ws5}";
        "${modifier}+6" = "workspace number ${ws6}";
        "${modifier}+7" = "workspace number ${ws7}";
        "${modifier}+8" = "workspace number ${ws8}";
        "${modifier}+9" = "workspace number ${ws9}";
        "${modifier}+0" = "workspace number ${ws10}";

        # move focused container to workspace
        "${modifier}+Shift+1" = "move container to workspace number ${ws1}";
        "${modifier}+Shift+2" = "move container to workspace number ${ws2}";
        "${modifier}+Shift+3" = "move container to workspace number ${ws3}";
        "${modifier}+Shift+4" = "move container to workspace number ${ws4}";
        "${modifier}+Shift+5" = "move container to workspace number ${ws5}";
        "${modifier}+Shift+6" = "move container to workspace number ${ws6}";
        "${modifier}+Shift+7" = "move container to workspace number ${ws7}";
        "${modifier}+Shift+8" = "move container to workspace number ${ws8}";
        "${modifier}+Shift+9" = "move container to workspace number ${ws9}";
        "${modifier}+Shift+0" = "move container to workspace number ${ws10}";

        # move focused container to scratchpad
        "${modifier}+Mod1+Shift+1" = ''mark "alpha", move scratchpad'';
        "${modifier}+Mod1+Shift+2" = ''mark "beta", move scratchpad'';
        "${modifier}+Mod1+Shift+3" = ''mark "gamma", move scratchpad'';
        "${modifier}+Mod1+Shift+4" = ''mark "delta", move scratchpad'';
        "${modifier}+Mod1+Shift+5" = ''mark "epsilon", move scratchpad'';
        "${modifier}+Mod1+Shift+6" = ''mark "zeta", move scratchpad'';
        "${modifier}+Mod1+Shift+7" = ''mark "eta", move scratchpad'';
        "${modifier}+Mod1+Shift+8" = ''mark "theta", move scratchpad'';
        "${modifier}+Mod1+Shift+9" = ''mark "iota", move scratchpad'';
        "${modifier}+Mod1+Shift+0" = ''mark "kappa", move scratchpad'';

        # toggle show container from scratchpad
        "${modifier}+Mod1+1" = ''[con_mark="alpha"] scratchpad show'';
        "${modifier}+Mod1+2" = ''[con_mark="beta"] scratchpad show'';
        "${modifier}+Mod1+3" = ''[con_mark="gamma"] scratchpad show'';
        "${modifier}+Mod1+4" = ''[con_mark="delta"] scratchpad show'';
        "${modifier}+Mod1+5" = ''[con_mark="epsilon"] scratchpad show'';
        "${modifier}+Mod1+6" = ''[con_mark="zeta"] scratchpad show'';
        "${modifier}+Mod1+7" = ''[con_mark="eta"] scratchpad show'';
        "${modifier}+Mod1+8" = ''[con_mark="theta"] scratchpad show'';
        "${modifier}+Mod1+9" = ''[con_mark="iota"] scratchpad show'';
        "${modifier}+Mod1+0" = ''[con_mark="kappa"] scratchpad show'';

        # move workspace between outputs
        "${modifier}+Control+Mod1+Right" = "move workspace to output right";
        "${modifier}+Control+Mod1+Left" = "move workspace to output left";

        "${modifier}+Control+Mod1+l" = "move workspace to output right";
        "${modifier}+Control+Mod1+h" = "move workspace to output left";

        # use left/right to rotate through workspaces; add Shift to move windows
        "${modifier}+Control+Left" = "workspace prev";
        "${modifier}+Control+Right" = "workspace next";
        "${modifier}+Control+Shift+Left" = "move workspace prev";
        "${modifier}+Control+Shift+Right" = "move workspace next";

        "${modifier}+Control+h" = "workspace prev";
        "${modifier}+Control+l" = "workspace next";
        "${modifier}+Control+Shift+h" = "move workspace prev";
        "${modifier}+Control+Shift+l" = "move workspace next";

        # reload the configuration file
        "${modifier}+Shift+c" = "reload";

        # restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
        "${modifier}+Shift+r" = "restart";

        # exit i3 (logs you out of your X session)
        "${modifier}+Shift+e" = ''
          exec swaynag -t warning -m 'You pressed the exit \
          shortcut. Do you really want to exit sway? This will end your Wayland session.' -b \
          'Yes, exit sway' 'sway exit'
        '';

        # lock the screen
        "${modifier}+o" = "exec ${pkgs.hyprlock}/bin/hyprlock";

        "${modifier}+Shift+s" = "exec ${pkgs.grim}/bin/grim ~/$(date +'%s_screenshot.png')";
        "${modifier}+Control+s" = ''
          exec '${pkgs.grim}/bin/grim -g "$(swaymsg -t get_tree | ${pkgs.jq}/bin/jq -j '.. | select(.type?) | select(.focused).rect | "\(.x),\(.y) \(.width)x\(.height)"')" ~/$(date +'%s_screenshot.png')'
        '';
        "${modifier}+Mod1+s" = ''
          exec '${pkgs.grim}/bin/grim -g "$(slurp)" - | ${pkgs.wl-clipboard-rs}/bin/wl-copy -t image/png'
        '';

        "${modifier}+r" = ''mode "resize"'';
        "${modifier}+m" = ''mode "music"'';
      };
      startup = [
        { command = ''wezterm start --class "wezterm-system"''; }
        { command = ''wezterm start --class "wezterm-audio" -- zsh -is eval 'pulsemixer' ''; }
        # Give Sway a little time to startup before starting kanshi
        { command = ''sleep 5; systemctl --user start kanshi.service''; }
        {
          command = ''sway output "*" bg ~/.background-image fill'';
          always = true;
        }
      ];
      window.commands = [
        {
          criteria = { app_id = "firefox"; };
          command = ''move --no-auto-back-and-forth window to workspace 1:web'';
        }
        {
          criteria = { app_id = "discord"; };
          command = ''move --no-auto-back-and-forth window to workspace 10:discord'';
        }
        {
          criteria = { app_id = "wezterm-system"; };
          command = ''mark "alpha", move scratchpad'';
        }
        {
          criteria = { app_id = "wezterm-audio"; };
          command = ''mark "beta", move scratchpad'';
        }
      ];
      modes = {
        resize = {
          # Shrink/grow window size.
          h = "resize shrink width 5 px or 5 ppt";
          j = "resize grow height 5 px or 5 ppt";
          k = "resize shrink height 5 px or 5 ppt";
          l = "resize grow width 5 px or 5 ppt";

          # Same bindings, but for the arrow keys
          Left = "resize shrink width 5 px or 5 ppt";
          Down = "resize grow height 5 px or 5 ppt";
          Up = "resize shrink height 5 px or 5 ppt";
          Right = "resize grow width 5 px or 5 ppt";

          # Resize and move to corner
          c = ''
            floating enable, resize set 20 ppt 20 ppt, \
            exec --no-startup-id ${./move_screen_ppt.sh} 79 77
          '';

          # Back to normal: Enter or Escape
          Return = "mode default";
          Escape = "mode default";
        };
        music = {
          # Bindings to control mpd.
          Return = "exec mpc play";
          s = "exec mpc stop";
          p = "exec mpc toggle";
          "Shift+period" = "exec mpc next";
          "Shift+comma" = "exec mpc prev";
          z = "exec mpc random";
          y = "exec mpc single";
          r = "exec mpc repeat";
          plus = "exec mpc volume +5";
          minus = "exec mpc volume -5";

          Escape = "mode default";
        };
      };
      bars = [
        {
          position = "bottom";
          fonts = { names = [ "Fira Code Custom" "Font Awesome 6 Free" ]; size = 10.0; };
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ${./i3status-rust.toml}";
        }
      ];
    };
  };
  # For monitor hot swapping
  systemd.user.services.kanshi = {
    Unit.Description = "kanshi daemon";
    Service = {
      Type = "simple";
      Environment = [
        "WAYLAND_DISPLAY=wayland-1"
        "DISPLAY=:0"
      ];
      ExecStart = ''${pkgs.kanshi}/bin/kanshi -c ${./kanshi_config}'';
    };
  };
}
