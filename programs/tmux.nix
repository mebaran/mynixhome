{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    escapeTime = 0;
    historyLimit = 100000;
    keyMode = "vi";
    mouse = true;
    newSession = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "tmux-256color";

    plugins = with pkgs.tmuxPlugins; [
      sensible
      better-mouse-mode
      pain-control
      session-wizard
      tmux-fzf
      yank
      {
        plugin = resurrect;
        extraConfig = "set -g @resurrect-capture-pane-contents 'on'";
      }
    ];

    extraConfig = ''
      # Terminal niceties
      set -as terminal-features ',xterm-256color:RGB,screen-256color:RGB,tmux-256color:RGB'
      set -g focus-events on
      set -g set-clipboard on
      set -g renumber-windows on
      set -g detach-on-destroy off

      # New panes and windows inherit the current directory.
      bind c new-window -c "#{pane_current_path}"
      bind '|' split-window -h -c "#{pane_current_path}"
      bind '-' split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # Easy navigation, resizing, reload, and window switching.
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5
      bind -n M-Left previous-window
      bind -n M-Right next-window
      bind r source-file ~/.config/tmux/tmux.conf \; display-message 'tmux config reloaded'

      # Vi-style copy mode.
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      # Tokyo City palette.
      set -g status-position top
      set -g status-interval 5
      set -g status-style 'bg=#171D23,fg=#A0A8B7'
      set -g status-left-length 40
      set -g status-right-length 80
      set -g status-left '#[bg=#65A7DE,fg=#171D23,bold] #S #[bg=#171D23,fg=#65A7DE]'
      set -g status-right '#[fg=#526270]#(whoami)@#H  #[fg=#A0A8B7]%a %d %b  #[bg=#E09A45,fg=#171D23,bold] %H:%M '
      set -g window-status-separator ""
      set -g window-status-format '#[fg=#526270]  #I:#W#F  '
      set -g window-status-current-format '#[fg=#171D23,bg=#A8C66C,bold] #I:#W#F #[default]'
      set -g pane-border-style 'fg=#303C47'
      set -g pane-active-border-style 'fg=#65A7DE'
      set -g pane-border-status top
      set -g pane-border-format ' #[fg=#526270]#{pane_index}: #{pane_title} '
      set -g message-style 'bg=#E09A45,fg=#171D23,bold'
      set -g mode-style 'bg=#A8C66C,fg=#171D23,bold'
    '';
  };
}
