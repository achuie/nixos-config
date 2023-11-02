{ config, lib, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    escapeTime = 50;
    historyLimit = 10000;
    keyMode = "vi";
    mouse = true;
    prefix = "C-a";
    terminal = "xterm-256color";
    extraConfig = ''
      # 256 colors
      set -ga terminal-overrides ",xterm-256color:Tc"

      # Vim bindings for switching panes
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Switch windows
      bind -r C-h select-window -t :-
      bind -r C-l select-window -t :+

      # Switch panes with Alt instead of prefix
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D
      bind -n M-h select-pane -L
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U
      bind -n M-l select-pane -R

      # Pane split bindings from i3
      bind v split-window -c "#{pane_current_path}"
      bind b split-window -h -c "#{pane_current_path}"
      bind C-o rotate-window

      # Kill current session and switch to next session
      bind-key X confirm-before -p "Kill #S (y/n)?" "run-shell 'tmux switch-client -n \\\; kill-session -t \"#S\"'"

      # Don't exit copy-mode on mouse select
      unbind -T copy-mode-vi MouseDragEnd1Pane

      # Vim-style begin selection
      bind -T copy-mode-vi v send -X begin-selection

      # Copy to and from system clipboard
      set -s set-clipboard off
      set -s copy-command "xclip -rmlastnl -in -selection clipboard"
      bind-key -T copy-mode-vi Y \
        send-keys -X copy-pipe-and-cancel "xclip -rmlastnl -in -selection primary" \; \
        display-message "Copied to selection"
      bind-key -T copy-mode-vi y \
        send-keys -X copy-pipe-and-cancel \; \
        display-message "Copied to clipboard"
      bind-key C-p run-shell "xclip -selection primary -out | tmux load-buffer - && tmux paste-buffer"

      # Double left mouse click to copy word
      bind-key -T copy-mode-vi DoubleClick1Pane \
        select-pane \; \
        send-keys -X select-word-no-clear \; \
        send-keys -X copy-pipe-no-clear "xclip -in -selection primary"
      bind-key -n DoubleClick1Pane \
        select-pane \; \
        copy-mode -M \; \
        send-keys -X select-word \; \
        send-keys -X copy-pipe-no-clear "xclip -in -selection primary"

      # Triple left mouse click to copy line
      bind-key -T copy-mode-vi TripleClick1Pane \
        select-pane \; \
        send-keys -X select-line \; \
        send-keys -X copy-pipe-no-clear "xclip -in -selection primary"
      bind-key -n TripleClick1Pane \
        select-pane \; \
        copy-mode -M \; \
        send-keys -X select-line \; \
        send-keys -X copy-pipe-no-clear "xclip -in -selection primary"

      # Create new window at current directory
      bind c new-window -c "#{pane_current_path}"

      # Toggle synchronize panes
      bind C-y setw synchronize-panes

      # Change colors based on synchronized or zoomed state
      set -g window-status-current-format "#{?pane_synchronized,#[bg=brightgreen],}#{?window_zoomed_flag,#[bg=brightyellow],}#I:#W"
      set -g window-status-format "#{?pane_synchronized,#[bg=brightgreen],}#{?window_zoomed_flag,#[bg=brightyellow],}#I:#W"

      # Emulate scrolling by sending up and down keys if these commands are running in the pane
      bind-key -T root WheelUpPane \
        if-shell -Ft= '#{?mouse_any_flag,1,#{pane_in_mode}}' \
          'send -Mt=' \
          'if-shell -t= "#{?alternate_on,true,false}" \
          "send -t= Up Up Up" "copy-mode -et="'

      bind-key -T root WheelDownPane \
        if-shell -Ft= '#{?mouse_any_flag,1,#{pane_in_mode}}' \
          'send -Mt=' \
          'if-shell -t= "#{?alternate_on,true,false}" \
          "send -t= Down Down Down" "copy-mode -et="'

      # Status bar bindings
      set -g status-keys vi

      # Status bar info
      set -g status-right "(#S) #{client_prefix,#[bg=brightgreen],}#{t:session_activity}"
      set -g status-left-length "100"
      set -g status-left "[#{=-97:pane_current_path}] "

      # Color theme
      setw -g pane-border-style "fg=brightblack"
      setw -g pane-active-border-style "fg=blue"
      setw -g status-style "fg=black dim,bg=blue"
      set -g window-status-current-style "bg=brightblue bold"
    '';
  };
}
