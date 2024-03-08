{ config, lib, pkgs, ... }:

let
  modifier = config.xsession.windowManager.i3.config.modifier;
  cfg = config.xsession.windowManager.i3.config;
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
in
{
  home.file.".xinitrc".source = ./xinitrc;
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = "Mod4";
      floating.modifier = "${modifier}";
      menu = ''${pkgs.dmenu-rs}/bin/dmenu_run --font "Fira Code Custom"'';
      workspaceAutoBackAndForth = true;
      fonts = { names = [ "Fira Code Custom" ]; size = 8.0; };
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
        "${modifier}+x" = "exec --no-startup-id ${./dyn_tags.sh}";
        "${modifier}+Shift+x" = "exec --no-startup-id ${./dyn_tags_mv.sh}";
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
          exec i3-nagbar -t warning -m 'You pressed the exit \
          shortcut. Do you really want to exit i3? This will end your X session.' -b \
          'Yes, exit i3' 'i3-msg exit'
        '';

        # lock the screen
        "--release ${modifier}+o" = "exec $HOME/.config/i3/lock.sh";

        "${modifier}+r" = ''mode "resize"'';
        "${modifier}+m" = ''mode "music"'';
      };
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
            exec --no-startup-id $HOME/.config/i3/move_screen_ppt.sh 79 77
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
}
